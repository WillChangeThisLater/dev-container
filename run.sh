#!/bin/bash
# Inspired by: https://www.youtube.com/watch?v=uqHjc7hlqd0 (James Pannacciulli Advanced Bash)
#
# This is a hack for mounting secrets into containers (or remote terminal sessions, or
# really anything that accepts input from a bash command)
#
# For some background: I split out my ZSH shell config into a couple of files:
# 
#   .zshrc                  <- for base commands I'd want to run anywhere
#   .zshrc-data-platform    <- for commands specific to my work (this includes system prompt)
#   .zshrc-gpt              <- for GPT related commands (mostly ask_gpt)
#   .zshrc-sensitive        <- for sensitive info. basically justs contains a bunch of API keys
#
# The idea is that I can use my ~/.zshrc file anywhere without worrying about leaking info
#
# That ~/.zshrc-sensitive file actually contains a big function def
#
# ```bash
# function secrets() {
#     AAA=1
#     BBB=2
#     CCC=3
# }
#
# secrets
# ```
#
# If I want to share these secrets with, say, a docker container, all I need to do is
# `$(declare -f secrets)` in my home environment (assuming ~/.zshrc-sensitive is sourced)
# and run 'secrets' in the container/remote machine/whatever and my secrets will propogate there as well. 

set -euo pipefail

container=${1:-pauljwendt/dev:latest}
deploy_to_k8s=0
for arg in "$@"
do
    if [ "$arg" == "--k8s" ]
    then
        deploy_to_k8s=1
    fi
done

if [ ! -f "$HOME/.zshrc-sensitive" ]; then
    echo "The secrets file does not exist. Exiting."
    exit 1
else
    source "$HOME/.zshrc-sensitive"
fi

# TODO: add a CLI argument, --k8s, for deploying to k8s.
# when this is not set docker should be used to run the container; otherwise kubectl should be used
if [ "$deploy_to_k8s" -eq "1" ]
then
    kubectl run dev-pod --image=pauljwendt/dev:latest -i --tty --rm -- /bin/sh -c "$(declare -f secrets); secrets; /bin/zsh"
else
    docker run -e DISPLAY=docker.for.mac.host.internal:0 -it "$container" zsh -c "$(declare -f secrets); secrets; /bin/zsh"
fi
