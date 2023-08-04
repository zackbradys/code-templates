### Install AWS CLI
mkdir -p /opt/rancher/aws
cd /opt/rancher/aws
curl -#OL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
rm -rf awscli-exe-linux-x86_64.zip
sudo ./aws/install
mv /usr/local/bin/aws /usr/bin/aws

### Install Cosign
mkdir -p /opt/rancher/cosign
cd /opt/rancher/cosign
curl -#OL https://github.com/sigstore/cosign/releases/download/v1.8.0/cosign-linux-amd64
mv cosign-linux-amd64 /usr/bin/cosign
chmod 755 /usr/bin/cosign

### Install Helm
mkdir -p /opt/rancher/helm
cd /opt/rancher/helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh && ./get_helm.sh
mv /usr/local/bin/helm /usr/bin/helm

### Update BASHRC with KUBECONFIG/PATH
cat << EOF >> ~/.bashrc
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/
EOF

### Source BASHRC
source ~/.bashrc

### Verify End of Script
date >> /opt/rancher/COMPLETED