#!/bin/bash

set -euo pipefail

# use CACHEBUST arg to make sure the dotfiles are re-installed and updated every time
docker build -t pauljwendt/dev:latest --build-arg CACHEBUST=$(date +%s) .
echo "$DOCKERHUB" | docker login --username pauljwendt --password-stdin
docker push pauljwendt/dev:latest
