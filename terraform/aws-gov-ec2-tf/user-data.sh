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

# install dependencies
yum clean all && yum upgrade -y
yum install -y zip zstd tree jq git

# install awscli
mkdir -p /opt/aws
cd /opt/aws
curl -sfOL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
rm -rf awscli-exe-linux-x86_64.zip
sudo ./aws/install --bin-dir /usr/bin

# install helm
mkdir -p /opt/helm
cd /opt/helm
curl -sfL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 755 get_helm.sh && ./get_helm.sh
sudo mv /usr/local/bin/helm /usr/bin/helm

# install hauler
curl -sfL https://get.hauler.dev | sudo HAULER_VERSION=${HaulerVersion} HAULER_INSTALL_DIR=/usr/bin bash

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
# date >> /opt/COMPLETED