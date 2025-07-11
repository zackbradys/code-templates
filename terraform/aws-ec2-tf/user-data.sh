#!/bin/bash

# clean and update operating system
sudo yum clean all
sudo yum upgrade -y

# install packages
sudo yum install -y git zip zstd tree jq
# sudo apt install -y git zip zstd tree jq

# install awscli
mkdir -p /opt/aws
cd /opt/aws
curl -sfOL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
rm -rf awscli-exe-linux-x86_64.zip
sudo ./aws/install --bin-dir /usr/bin

# install docker and docker compose
mkdir /opt/docker
cd /opt/docker
sudo yum install -y docker
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod 755 /usr/bin/docker-compose
sudo systemctl enable --now docker

# install btop
mkdir /opt/btop
cd /opt
sudo curl -L https://github.com/aristocratos/btop/releases/download/v1.4.0/btop-x86_64-linux-musl.tbz -o btop-x86_64-linux-musl.tbz
tar -xvf btop-x86_64-linux-musl.tbz && cd /opt/btop
rm -rf /opt/btop-x86_64-linux-musl.tbz
sudo cp bin/btop /usr/bin/

# install helm
mkdir -p /opt/helm
cd /opt/helm
curl -sfL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 755 get_helm.sh && ./get_helm.sh
sudo mv /usr/local/bin/helm /usr/bin/helm

# install go
mkdir -p /opt/go
cd /opt/go
sudo rm -rf /usr/local/go
curl -sfOL https://go.dev/dl/go1.21.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# install goreleaser
name=GoReleaser
baseurl=https://repo.goreleaser.com/yum/
enabled=1
gpgcheck=0 | sudo tee /etc/yum.repos.d/goreleaser.repo

# install goreleaser
# echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | sudo tee /etc/apt/sources.list.d/goreleaser.list
# sudo apt update

# install hauler
curl -sfL https://get.hauler.dev | sudo HAULER_VERSION=1.2.4 HAULER_INSTALL_DIR=/usr/bin bash

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sudo sh
sudo tailscale up --accept-routes --auth-key=${TailscaleToken}

# verify end of script
date >> /opt/COMPLETED
