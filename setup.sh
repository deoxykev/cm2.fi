#!/bin/bash
sudo add-apt-repository ppa:ondrej/nginx
sudo apt update
sudo apt upgrade -y
sudo apt install git nginx libnginx-mod-http-lua -y
