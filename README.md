## What is this?
My personal debugging dev container

I want to be able to carry my development environment
with me everywhere. This isn't a perfect replica of
what my local setup looks like, but is close enough
to be useful.

I think this will be especially useful for debugging k8s
related issues. A pattern I fall into ofter for doing this
is spinning up a vanilla pod like `ubuntu:latest` and manually
installing all the utils I need there. But this dev container
has all the utils I need ready to go. And, because I've included
a couple CLI programs I use for interacting with LLMs
(`lm` and `debug`), I can interact with LLMs seamlessly.

## How do I use this?
`./run.sh` if you want to spin up a local container in Docker
`./run.sh --k8s` if you want to spin up a remote container in k8s


# Design related thoughts
## Requirements (for the dev container)
- Should support various programs and languages
  - Languages: python, go
  - Utilities:
    - Basic Dev: ssh, git, neovim, tmux, ngrok, zsh
    - Build tools: cmake 
    - Networking: curl, wget, unzip, zip, jq, yq, mitmproxy, lsof, netcat, nmap, ping, socat
    - Ease of Access: X11
  - Local programs I wrote and use
    - `lm`

- Should support my personal configs for programs, when applicable
  - `neovim` should use my local config
  - `tmux` should use my local config
  - `zsh` should use my local config

- Reasonable defaults
  - Shell should be zsh

## Other requirements
- It should be easy for me to spin up this container in a cluster
- It should be easy for me to mount local creds into the container (use the `declare` trick)
- It should be easy for me to mount local files and directories into the container.
  Perhaps the relationship should be two way (e.g. local updates are reflected in container files and vice versa)
