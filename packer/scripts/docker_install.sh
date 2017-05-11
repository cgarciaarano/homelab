#!/bin/bash -eux

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
usermod -aG docker vagrant

# Docker compose, installed as container with a shell wrapper
wget https://github.com/docker/compose/releases/download/1.12.0/run.sh -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Alpine stuff
# apk add docker
# rc-update add docker boot
# adduser vagrant docker
# apk add py-pip
# pip install docker-compose