#!/bin/bash

set -ebpf

### Set Variables
export DOMAIN=${DOMAIN}
export TOKEN=${TOKEN}
export vRKE2=${vRKE2}

### Install Packages
yum install -y zip zstd tree jq iptables container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum install -y nfs-utils && yum install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

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

### Setup RKE2 Server
mkdir -p /opt/rke2-artifacts
cd /opt/rke2-artifacts
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
mkdir -p /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.23
selinux: true
secrets-encryption: true
write-kubeconfig-mode: 0640
use-service-account-credentials: true
kube-controller-manager-arg:
- bind-address=127.0.0.1
- use-service-account-credentials=true
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
kube-scheduler-arg:
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
kube-apiserver-arg:
- tls-min-version=VersionTLS12
- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- authorization-mode=RBAC,Node
- anonymous-auth=false
- audit-policy-file=/etc/rancher/rke2/audit-policy.yaml
- audit-log-mode=blocking-strict
- audit-log-maxage=30
kubelet-arg:
- protect-kernel-defaults=true
- read-only-port=0
- authorization-mode=Webhook
- streaming-connection-idle-timeout=5m
- max-pods=200
cloud-provider-name: aws
token: $TOKEN
tls-san:
  - $DOMAIN
EOF

### Configure RKE2 Audit Policy
cat << EOF >> /etc/rancher/rke2/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
EOF

### Congiure NGINX Policies
cat << EOF >> /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml
---
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      config:
        use-forwarded-headers: true
      extraArgs:
        enable-ssl-passthrough: true
EOF

### Download and Install RKE2 Server
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=$vRKE2 INSTALL_RKE2_TYPE=server sh -

### Enable and Start RKE2 Server
systemctl enable rke2-server.service && systemctl start rke2-server.service

### Symlink kubectl and containerd
sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

### Update BASHRC with KUBECONFIG/PATH
cat << EOF >> ~/.bashrc
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/var/lib/rancher/rke2/bin:/usr/local/bin/
export DOMAIN=$DOMAIN
export TOKEN=$TOKEN
export vRKE2=$vRKE2
alias k=kubectl
EOF

### Source BASHRC
source ~/.bashrc

### Verify End of Script
date >> /opt/rancher/COMPLETED