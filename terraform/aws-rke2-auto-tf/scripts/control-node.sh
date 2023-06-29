#!/bin/bash

set -ebpf

### Set Variables
export DOMAIN=${DOMAIN}
export TOKEN=${TOKEN}
export vRKE2=${vRKE2}

### Applying System Settings
cat << EOF >> /etc/sysctl.conf
# SWAP Settings
vm.swappiness=0
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
vm.max_map_count = 262144

# IPv4 Connection Settings
net.ipv4.ip_local_port_range=1024 65000

# Increase Max Connection
net.core.somaxconn=10000

# Closed Socket Settings
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15

# Increasing Backlogged Sockets (Default is 128)
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096

# Increasing Socket Buffers
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# Network Tuning Settings
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216

# ARP Cache Settings
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384

# More IPv4 Settings
net.ipv4.tcp_keepalive_time=600
net.ipv4.ip_forward=1

# File System Monitoring
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
EOF

sysctl -p > /dev/null 2>&1

### Install Packages
yum install -y zip zstd tree jq iptables container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup
yum --setopt=tsflags=noscripts install -y nfs-utils
yum --setopt=tsflags=noscripts install -y iscsi-initiator-utils && echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf
yum update -y && yum clean all

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

### Install Root Certificate
mkdir -p /opt/rancher/certs
cd /opt/rancher/certs
cat << EOF >> /opt/rancher/certs/bgh-root-ca.pem
-----BEGIN CERTIFICATE-----
MIIEVzCCAz+gAwIBAgIUbplB4EDeCkVhNpw/rXiZl6a/G7cwDQYJKoZIhvcNAQEL
BQAwgboxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhEZWxhd2FyZTEOMAwGA1UEBwwF
RG92ZXIxIjAgBgNVBAoMGUJyYWR5IEdsb2JhbCBIb2xkaW5ncyBMTEMxHjAcBgNV
BAsMFUJyYWR5IEdsb2JhbCBIb2xkaW5nczEUMBIGA1UEAwwLQkdIIFJvb3QgQ0Ex
LjAsBgkqhkiG9w0BCQEWH2NvbnRhY3RAYnJhZHlnbG9iYWxob2xkaW5ncy5jb20w
HhcNMjMwMjE4MDQyNDAzWhcNNDIxMTA1MDQyNDAzWjCBujELMAkGA1UEBhMCVVMx
ETAPBgNVBAgMCERlbGF3YXJlMQ4wDAYDVQQHDAVEb3ZlcjEiMCAGA1UECgwZQnJh
ZHkgR2xvYmFsIEhvbGRpbmdzIExMQzEeMBwGA1UECwwVQnJhZHkgR2xvYmFsIEhv
bGRpbmdzMRQwEgYDVQQDDAtCR0ggUm9vdCBDQTEuMCwGCSqGSIb3DQEJARYfY29u
dGFjdEBicmFkeWdsb2JhbGhvbGRpbmdzLmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAKR0QpSj7APcWsjgTQK+z6P5eVoNc73t5dAXHcImy830q+b+
9Y4Dll+2uC718t5ais+fVGo4lEpiKnp5Nv/6CerrSISrKxtzhrVK9ro02GE9lp/9
8zdrgK8tvssJRu5e9Af/9+DpuIfOqeBuN1bSdD9/fa/K700WWbYJVF95dYqRi5Dl
JZLNmqpxTfQLuxFRwRo4XTCSYbCdoYBX27V0VdEN8PRwl11aNyqZ1oUeX0buvQa/
H6STNk6VyKO5jYyvezPnx+xH92SdIU42kXNHFNp5FSQiM3D9+BfirHS66PwFRUgb
tSDJ+EpBqcYKLoMyW0zBPjGY0a24dxZEZRrAcXcCAwEAAaNTMFEwHQYDVR0OBBYE
FGs5Vk7NhxbdUfv90fJ3DUk2i+muMB8GA1UdIwQYMBaAFGs5Vk7NhxbdUfv90fJ3
DUk2i+muMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAAxJ+8se
WxWN5ogrqhHKGknKCVUZHRtHPdo8UgTRl6qPJW6/ifjRVI+ep6kKbf3rCBKEEKRx
z0jBoNqjXPq9pcmJAaRg3AAz/Vr3eq7qsknNYXycdUKi8tO3g9F88tJxsRF81jiy
a2LU5HIyINiyfpqndn07quuMEB57wt3PrqOyik6E6QvOoMxoQfh5KYfaQnw7y1Jp
BopE1tjd/MdoqKmU7Bt/HKlAdu9MQiDCB33Bm7J2xMAGh0IIhlvq05Wsj2IYihB/
TkJFOYKnQhf38ZyKmJYPpwoeFOf4qn6RwwkUhPAjklRsyY4CPKC/ZNDZWyslwiMT
5/HJF95iiluUizM=
-----END CERTIFICATE-----
EOF
cp bgh-root-ca.pem /etc/pki/ca-trust/source/anchors/
update-ca-trust enable && update-ca-trust extract && update-ca-trust

### Setup RKE2 Server
mkdir -p /opt/rke2-artifacts
cd /opt/rke2-artifacts
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
mkdir -p /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.6
selinux: true
secrets-encryption: true
write-kubeconfig-mode: 0600
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
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=$vRKE2 INSTALL_RKE2_TYPE=server sh -

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