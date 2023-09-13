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

### Setup RKE2 Agent
mkdir -p /etc/rancher/rke2/

### Configure RKE2 Config
cat << EOF >> /etc/rancher/rke2/config.yaml
#profile: cis-1.23
write-kubeconfig-mode: 0640
kube-apiserver-arg:
- authorization-mode=RBAC,Node
kubelet-arg:
- protect-kernel-defaults=true
- read-only-port=0
- authorization-mode=Webhook
- max-pods=200
cloud-provider-name: aws
server: https://$DOMAIN:9345
token: $TOKEN
EOF

### Download and Install RKE2 Agent
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=$vRKE2 INSTALL_RKE2_TYPE=agent sh -

### Configure RKE2 Agent Finalizers
mkdir -p /opt/rancher
cat << EOF >> /opt/rancher/rke2-agent-finalizer.txt
1) Copy and paste the following command to start the rke2-agent:
systemctl enable rke2-agent.service && systemctl start rke2-agent.service
EOF