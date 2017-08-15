#! /usr/bin/env bash
#
#
# need to be root


# install docker
if ! command docker &>/dev/null; then
  apt-get remove docker docker-engine docker.io

  apt-get update
  apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  apt-key fingerprint 0EBFCD88

  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

  apt-get update
  apt-get install -y docker-ce

  apt-get autoremove
fi

# install docker-compose
DOCKER_COMPOSE_PATH=/usr/local/bin/docker-compose
if [[ ! -f $DOCKER_COMPOSE_PATH ]]; then
  curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > $DOCKER_COMPOSE_PATH
  chmod +x $DOCKER_COMPOSE_PATH
fi






