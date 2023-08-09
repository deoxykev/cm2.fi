#!/bin/bash
# install docker

set -xe
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
apt install docker-compose -y

exit 0
