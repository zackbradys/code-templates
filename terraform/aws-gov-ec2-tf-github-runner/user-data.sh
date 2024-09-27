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

# install github self hosted runner
mkdir -p /opt/github
chmod 777 /opt/github
cd /opt/github
export svc_user="ec2-user"
export RUNNER_ALLOW_RUNASROOT="1"
export RUNNER_CFG_PAT="${GitHubToken}"

yum install -y lttng-ust openssl-libs krb5-libs zlib libicu
curl -sfOL https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh
chmod 755 create-latest-svc.sh
./create-latest-svc.sh -s zackbradys/"${GitHubRepository}" -n github-runner-"${GitHubRepository}"-"$(date "+%Y-%m-%d")-"${RunnerIndex}""

# modify permissions
chmod -R 777 /opt/

# verify end of script
date >> /opt/COMPLETED
