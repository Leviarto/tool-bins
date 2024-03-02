#!/bin/bash

# install act (local execution of github actions)
(
  cd /
  curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
)

# build custom runner image
docker buildx build --platform linux/amd64 --tag act-runner-custom-ubuntu-22-04 ./.act/custom-runner_ubuntu-22.04/
