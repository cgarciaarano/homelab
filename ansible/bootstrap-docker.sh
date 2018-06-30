#!/bin/bash -eux

# Bootstrap Docker & Docker Compose installation
# Valid for Debian/Ubuntu flavours

COMPOSE_VERSION="1.22.0"

apt update && apt install -y \
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

apt update && apt install -y docker-ce
usermod -aG docker $SUDO_USER

# Docker compose, installed as container with a shell wrapper
wget https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/run.sh -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose