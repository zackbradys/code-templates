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

# install docker
mkdir /opt/docker
cd /opt/docker
yum install -y docker
systemctl enable --now docker

# install docker compose plugin
mkdir -p /usr/libexec/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# install btop
mkdir /opt/btop
cd /opt
curl -L https://github.com/aristocratos/btop/releases/download/v1.4.7/btop-x86_64-unknown-linux-musl.tar.gz -o btop-x86_64-unknown-linux-musl.tar.gz
tar -xvf btop-x86_64-unknown-linux-musl.tar.gz
rm -rf /opt/btop-x86_64-unknown-linux-musl.tar.gz
cp /opt/btop/bin/btop /usr/bin/btop

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
curl -sfL https://get.hauler.dev | sudo HAULER_INSTALL_DIR=/usr/bin bash

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sudo sh
sudo tailscale up --accept-routes --auth-key=${TailscaleToken}

# verify end of script
date >> /opt/COMPLETED
