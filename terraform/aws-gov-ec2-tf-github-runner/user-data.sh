#!/bin/bash

# set variables
cat << EOF >> ~/.bashrc
export CarbideLicense=${CarbideLicense}
export Registry=${Registry}
export RegistryUsername=${RegistryUsername}
export RegistryPassword=${RegistryPassword}
export GitHubUsername=${GitHubUsername}
export GitHubToken=${GitHubToken}
export GitHubRepository=${GitHubRepository}
export RUNNER_CFG_PAT=${GitHubToken}
export AWS_ACCESS_KEY_ID=${AccessKey}
export AWS_SECRET_ACCESS_KEY=${SecretKey}
export AWS_DEFAULT_REGION=${Region}
export HaulerVersion=${HaulerVersion}
export HAULER_IGNORE_ERRORS=true
EOF

# source bashrc
source ~/.bashrc

cat << EOF >> /home/ec2-user/.bashrc
export CarbideLicense=${CarbideLicense}
export Registry=${Registry}
export RegistryUsername=${RegistryUsername}
export RegistryPassword=${RegistryPassword}
export GitHubUsername=${GitHubUsername}
export GitHubToken=${GitHubToken}
export GitHubRepository=${GitHubRepository}
export RUNNER_CFG_PAT=${GitHubToken}
export AWS_ACCESS_KEY_ID=${AccessKey}
export AWS_SECRET_ACCESS_KEY=${SecretKey}
export AWS_DEFAULT_REGION=${Region}
export HaulerVersion=${HaulerVersion}
export HAULER_IGNORE_ERRORS=true
EOF

# source bashrc
source /home/ec2-user/.bashrc

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
# mkdir -p /opt/helm
# cd /opt/helm
# curl -sfL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 755 get_helm.sh && ./get_helm.sh
# sudo mv /usr/local/bin/helm /usr/bin/helm

# install go
# mkdir -p /opt/go
# cd /opt/go
# sudo rm -rf /usr/local/go
# curl -sfOL https://go.dev/dl/go1.21.13.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz
# echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

# install goreleaser
# name=GoReleaser
# baseurl=https://repo.goreleaser.com/yum/
# enabled=1
# gpgcheck=0 | sudo tee /etc/yum.repos.d/goreleaser.repo

# install goreleaser
# echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | sudo tee /etc/apt/sources.list.d/goreleaser.list
# sudo apt update

# install hauler
curl -sfL https://get.hauler.dev | sudo HAULER_VERSION=1.1.1 HAULER_INSTALL_DIR=/usr/bin bash

# install p7zip
mkdir -p /opt/p7zip
cd /opt/p7zip
curl -sfOL https://www.7-zip.org/a/7z2408-linux-x64.tar.xz
tar -xf 7z2408-linux-x64.tar.xz
chmod 755 7zz
sudo mv 7zz /usr/bin/7z

# install github self hosted runner
mkdir -p /opt/github
chmod 777 /opt/github
cd /opt/github
export svc_user="ec2-user"
export RUNNER_ALLOW_RUNASROOT="1"
export RUNNER_CFG_PAT="${GitHubToken}"

sudo yum install -y lttng-ust openssl-libs krb5-libs zlib libicu
curl -sfOL https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh
sudo chmod 755 create-latest-svc.sh
./create-latest-svc.sh -s zackbradys/"${GitHubRepository}" -n github-runner-"${GitHubRepository}"-"$(date "+%Y-%m-%d")-"${RunnerIndex}""

# modify permissions
sudo chmod -R 777 /opt/

# verify end of script
date >> /opt/COMPLETED
