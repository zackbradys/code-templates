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
# mkdir /opt/docker
# cd /opt/docker
# sudo yum install -y docker
# sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
# sudo chmod 755 /usr/bin/docker-compose
# sudo systemctl enable --now docker

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

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sudo sh
sudo tailscale up --auth-key=${TailscaleToken}

# verify end of script
date >> /opt/COMPLETED

# sudo yum update -y
# sudo yum groupinstall -y 'Server with GUI'
# sudo yum groupinstall -y GNOME
# sudo sed -i '/^\[daemon\]/a WaylandEnable=false' /etc/gdm/custom.conf
# sudo yum install -y xorg-x11-drv-dummy

# sudo tee /etc/X11/xorg.conf > /dev/null << EOF
# Section "Device"
#     Identifier "DummyDevice"
#     Driver "dummy"
#     Option "UseEDID" "false"
#     VideoRam 512000
# EndSection

# Section "Monitor"
#     Identifier "DummyMonitor"
#     HorizSync   5.0 - 1000.0
#     VertRefresh 5.0 - 200.0
#     Option "ReducedBlanking"
# EndSection

# Section "Screen"
#     Identifier "DummyScreen"
#     Device "DummyDevice"
#     Monitor "DummyMonitor"
#     DefaultDepth 24
#     SubSection "Display"
#         Viewport 0 0
#         Depth 24
#         Virtual 4096 2160
#     EndSubSection
# EndSection
# EOF

# sudo systemctl stop firewalld
# sudo systemctl isolate multi-user.target && sudo systemctl isolate graphical.target

# # verify end of script
# date >> /opt/COMPLETED-AGAIN
