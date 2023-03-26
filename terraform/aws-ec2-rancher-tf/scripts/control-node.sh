#!/bin/bash

set -ebpf

### Applying MOTD Banner
cat << EOF >> /etc/motd

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#             ______       ______     ____  ____        _____     _____       ______              #
#            |_   _ \    .' ___  |   |_   ||   _|      |_   _|   |_   _|    .' ___  |             #
#              | |_) |  / .'   \_|     | |__| |          | |       | |     / .'   \_|             #
#              |  __'.  | |   ____     |  __  |          | |   _   | |   _ | |                    #
#             _| |__) |_\ `.___]  |_  _| |  | |_  _     _| |__/ | _| |__/ |\ `.___.'\             #
#            |_______/(_)`._____.'(_)|____||____|(_)   |________||________| `.____ .'             #
#                                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                                 #
#    0100001001010010010000010100010001011001 010001110100110001001111010000100100000101001100    #
#    100100001001111010011000100010001001001010011100100011101010011  010011000100110001000011    #
#                                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                                 #
#      WARNING!! You are connecting to a server managed, owned, and operated by Brady Global      #
#               Holdings LLC. All activity and usage is logged and monitored.                     #
#                                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

EOF

systemctl restart sshd

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
yum update -y
yum install -y zip zstd skopeo tree jq iptables container-selinux iptables libnetfilter_conntrack libnfnetlink libnftnl policycoreutils-python-utils cryptsetup iscsi-initiator-utils
systemctl enable --now iscsid && echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf

### Install AWS CLI
mkdir -p /opt/rancher/aws
cd /opt/rancher/aws
curl -#OL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
rm -rf awscli-exe-linux-x86_64.zip
sudo ./aws/install

### Install Terraform
mkdir -p /opt/rancher/terraform
cd /opt/rancher/terraform
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

### Install Cosign
mkdir -p /opt/rancher/cosign
cd /opt/rancher/cosign
curl -#OL https://github.com/sigstore/cosign/releases/download/v1.8.0/cosign-linux-amd64
mv cosign-linux-amd64 /usr/local/bin/cosign
chmod 755 /usr/local/bin/cosign

### Install Helm
mkdir -p /opt/rancher/helm
cd /opt/rancher/helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh && ./get_helm.sh

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
streaming-connection-idle-timeout: 5m
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
server: https://:9345
token: 
tls-san:
  - 
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

### Download RKE2 Binaries
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24 INSTALL_RKE2_TYPE=server sh - 

### Configure RKE2 Control Finalizers
cat << EOF >> /opt/rancher/rke2-control-finalizer.txt

### Ensure you update the server, token, and tls-san values in /etc/rancher/rke2/config.yaml
### Ensure you have DNS Round Robin setup so the server can be reached on the set domain
### After completeing those changes, run the following commands to start the rke2-server:

systemctl enable rke2-server.service && systemctl start rke2-server.service

cat /var/lib/rancher/rke2/server/token > /opt/rancher/token
cat /opt/rancher/token

sudo ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl /usr/local/bin/kubectl
sudo ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock

export KUBECONFIG=/etc/rancher/rke2/rke2.yaml 
export PATH=$PATH;/var/lib/rancher/rke2/bin;/usr/local/bin/
alias k=kubectl
EOF