#!/bin/bash

# install dependencies
yum clean all && yum upgrade -y

# install awscli
mkdir -p /opt/aws
cd /opt/aws
curl -sfOL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
rm -rf awscli-exe-linux-x86_64.zip
sudo ./aws/install

# install helm
mkdir -p /opt/helm
cd /opt/helm
curl -sfL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 755 get_helm.sh && ./get_helm.sh
sudo mv /usr/local/bin/helm /usr/bin/helm

# install go
# mkdir -p /opt/go
# cd /opt/go
# sudo rm -rf /usr/local/go
# curl -sfOL https://go.dev/dl/go1.21.13.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz
# echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# install packages
# name=GoReleaser
# baseurl=https://repo.goreleaser.com/yum/
# enabled=1
# gpgcheck=0 | sudo tee /etc/yum.repos.d/goreleaser.repo
# sudo yum clean all && sudo yum update -y
#sudo yum install -y goreleaser git zip zstd tree jq

# install packages
# echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | sudo tee /etc/apt/sources.list.d/goreleaser.list
# sudo apt update
# sudo apt install -y goreleaser git zip zstd tree jq

# install hauler
curl -sfL https://get.hauler.dev | sudo HAULER_VERSION=1.1.0-rc.1 HAULER_INSTALL_DIR=/usr/bin bash

# verify end of script
date >> /opt/COMPLETED
