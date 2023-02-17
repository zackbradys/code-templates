## Reference Docs

https://github.com/zackbradys/effortless-rancher

https://docs.rke2.io/

https://ranchermanager.docs.rancher.com/

https://helm.sh/docs/

https://longhorn.io/docs/

https://open-docs.neuvector.com

## High Availability Docs
https://docs.rke2.io/install/ha

https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher

https://helm.sh/docs/intro/quickstart/


## STEP1
aquire 3 internet connected vms

### HA-ONLY
aquire 6 internet connected vms


## STEP2
yum install -y nfs-utils cryptsetup iscsi-initiator-utils; systemctl start iscsid.service; systemctl enable iscsid.service
echo -e "[keyfile]\nunmanaged-devices=interface-name:cali*;interface-name:flannel*" > /etc/NetworkManager/conf.d/rke2-canal.conf


## STEP3
vi /etc/sysctl.conf

### SWAP Settings
vm.swappiness=0
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
vm.max_map_count = 262144

### IPV4 Larger Connection Range
net.ipv4.ip_local_port_range=1024 65000

### Increase Max Connections
net.core.somaxconn=10000

### Reuse Closed Sockets Faster
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15

### The maximum number of "backlogged sockets".  Default is 128.
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096
net.core.rmem_max=16777216
net.core.wmem_max=16777216

### Various Network Tuning
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216

### ARP Cache Settings
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384

### IPV4 Forward and TCP KeepAlive
net.ipv4.tcp_keepalive_time=600
net.ipv4.ip_forward=1

### Monitor File System Events
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576


## STEP4
vi /etc/sysconfig/network-scripts/ifcfg-eth0

BOOTPROTO=none

PROXY_METHOD=none
BROWSER_ONLY=no
IPADDR=10.0.0.$IP
PREFIX=24
GATEWAY=10.0.0.1
DNS1=10.0.0.12
DNS2=1.1.1.1
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME="System eth0"
UUID=5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03


## STEP5
reboot


## STEP6 - first control
mkdir /opt/rke2-artifacts
cd /opt/rke2-artifacts/
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
mkdir -p /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/

### basic config.yaml
echo -e "#profile: cis-1.6\nselinux: true\nsecrets-encryption: true\nwrite-kubeconfig-mode: 0600\nstreaming-connection-idle-timeout: 5m\nkube-controller-manager-arg:\n- bind-address=127.0.0.1\n- use-service-account-credentials=true\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\nkube-scheduler-arg:\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\nkube-apiserver-arg:\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\n- authorization-mode=RBAC,Node\n- anonymous-auth=false\n- audit-policy-file=/etc/rancher/rke2/audit-policy.yaml\n- audit-log-mode=blocking-strict\n- audit-log-maxage=30\nkubelet-arg:\n- protect-kernel-defaults=true\n- read-only-port=0\n- authorization-mode=Webhook" > /etc/rancher/rke2/config.yaml

### audit policy file
echo -e "apiVersion: audit.k8s.io/v1\nkind: Policy\nrules:\n- level: RequestResponse" > /etc/rancher/rke2/audit-policy.yaml

### ssl passthrough for nginx
echo -e "---\napiVersion: helm.cattle.io/v1\nkind: HelmChartConfig\nmetadata:\n  name: rke2-ingress-nginx\n  namespace: kube-system\nspec:\n  valuesContent: |-\n    controller:\n      config:\n        use-forwarded-headers: true\n      extraArgs:\n        enable-ssl-passthrough: true" > /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml; 

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24.9 sh - 

systemctl enable rke2-server.service && systemctl start rke2-server.service

mkdir /opt/rancher
cat /var/lib/rancher/rke2/server/token > /opt/rancher/token
cat /opt/rancher/token

### HA-ONLY
vi /etc/rancher/rke2/config.yaml

tls-san:
  - $DOMAIN-FQDN

echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml PATH=$PATH:/var/lib/rancher/rke2/bin" >> ~/.bashrc
ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl  /usr/local/bin/kubectl
ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock
chmod 777 -R /etc/rancher/rke2/
source ~/.bashrc 


## STEP7 - second/third control
mkdir /opt/rke2-artifacts
cd /opt/rke2-artifacts/
useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
mkdir -p /etc/rancher/rke2/ /var/lib/rancher/rke2/server/manifests/

### basic config.yaml
echo -e "#profile: cis-1.6\nselinux: true\nsecrets-encryption: true\nwrite-kubeconfig-mode: 0600\nstreaming-connection-idle-timeout: 5m\nkube-controller-manager-arg:\n- bind-address=127.0.0.1\n- use-service-account-credentials=true\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\nkube-scheduler-arg:\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\nkube-apiserver-arg:\n- tls-min-version=VersionTLS12\n- tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384\n- authorization-mode=RBAC,Node\n- anonymous-auth=false\n- audit-policy-file=/etc/rancher/rke2/audit-policy.yaml\n- audit-log-mode=blocking-strict\n- audit-log-maxage=30\nkubelet-arg:\n- protect-kernel-defaults=true\n- read-only-port=0\n- authorization-mode=Webhook" > /etc/rancher/rke2/config.yaml

### audit policy file
echo -e "apiVersion: audit.k8s.io/v1\nkind: Policy\nrules:\n- level: RequestResponse" > /etc/rancher/rke2/audit-policy.yaml

### ssl passthrough for nginx
echo -e "---\napiVersion: helm.cattle.io/v1\nkind: HelmChartConfig\nmetadata:\n  name: rke2-ingress-nginx\n  namespace: kube-system\nspec:\n  valuesContent: |-\n    controller:\n      config:\n        use-forwarded-headers: true\n      extraArgs:\n        enable-ssl-passthrough: true" > /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml; 

vi /etc/rancher/rke2/config.yaml

### HA-ONLY
server: https://$SERVER-FQDN:9345
token: $CLUSTER-JOIN-TOKEN
tls-san:
  - $DOMAIN-FQDN

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24.9 sh - 

systemctl enable rke2-server.service && systemctl start rke2-server.service

echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml PATH=$PATH:/var/lib/rancher/rke2/bin" >> ~/.bashrc
ln -s /var/lib/rancher/rke2/data/v1*/bin/kubectl  /usr/local/bin/kubectl
ln -s /var/run/k3s/containerd/containerd.sock /var/run/containerd/containerd.sock
chmod 777 -R /etc/rancher/rke2/
source ~/.bashrc 


## STEP8 - three workers
mkdir -p /etc/rancher/rke2/
echo -e "write-kubeconfig-mode: 0640\n#profile: cis-1.6\nkube-apiserver-arg:\n- \"authorization-mode=RBAC,Node\"\nkubelet-arg:\n- \"protect-kernel-defaults=true\" " > /etc/rancher/rke2/config.yaml

chmod 600 /etc/rancher/rke2/config.yaml

vi /etc/rancher/rke2/config.yaml

server: https://$SERVER-FQDN:9345
token: $CLUSTER-JOIN-TOKEN

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.24.9 INSTALL_RKE2_TYPE=agent sh -

systemctl enable rke2-agent.service && systemctl start rke2-agent.service


## STEP9 - helm
mkdir /opt/rancher/helm
cd /opt/rancher/helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh && ./get_helm.sh

helm repo add jetstack https://charts.jetstack.io 
helm repo add longhorn https://charts.longhorn.io
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add neuvector https://neuvector.github.io/neuvector-helm/
helm repo add harbor https://helm.goharbor.io
helm repo update

## STEP10 - longhorn
helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --set ingress.enabled=true --set ingress.host=longhorn.7310hargrove.court


## STEP11 - rancher
helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true

helm upgrade -i rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set bootstrapPassword=Pa22word --set replicas=3 --set auditLog.level=2 --set auditLog.destination=hostPath --set hostname=rancher.7310hargrove.court


## STEP12 - neuvector
helm upgrade -i neuvector neuvector/core --namespace neuvector --create-namespace  --set imagePullSecrets=regsecret --set k3s.enabled=true --set k3s.runtimePath=/run/k3s/containerd/containerd.sock  --set manager.ingress.enabled=true --set controller.pvc.enabled=true --set manager.svc.type=ClusterIP --set controller.pvc.capacity=500Mi --set controller.image.repository=neuvector/controller --set enforcer.image.repository=neuvector/enforcer --set manager.image.repository=neuvector/manager --set cve.updater.image.repository=neuvector/updater --set manager.ingress.host=neuvector.7310hargrove.court


## STEP13 - harbor
helm upgrade -i harbor harbor/harbor --namespace harbor --create-namespace --set expose.tls.enabled=false --set expose.tls.auto.commonName=harbor.7310hargrove.court --set expose.ingress.hosts.core=harbor.7310hargrove.court --set persistence.enabled=true --set harborAdminPassword=Pa22word --set externalURL=http://harbor.7310hargrove.court --set notary.enabled=false


## EXTRAS

WIP