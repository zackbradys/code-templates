#!/bin/bash

set -ebpf

### Add Required Helm Repos
helm repo add jetstack https://charts.jetstack.io 
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add longhorn https://charts.longhorn.io
helm repo add neuvector https://neuvector.github.io/neuvector-helm
helm repo add harbor https://helm.goharbor.io
helm repo add kubewarden https://charts.kubewarden.io
helm repo add carbide-charts https://rancherfederal.github.io/carbide-charts
helm repo add zackbradys https://zackbradys.github.io/helm-charts
helm repo update

### Install Rancher Federal IO Certificates
cd /opt/rancher/certs
cp bgh-root-ca.pem ca.pem

cat <<EOF >> wildcard.rancherfederal.io.pem
-----BEGIN CERTIFICATE-----
MIIFZTCCBE2gAwIBAgIUWHB2mmiMC6YVb2TNeXslFGkh+vowDQYJKoZIhvcNAQEL
BQAwgboxCzAJBgNVBAYTAlVTMREwDwYDVQQIDAhEZWxhd2FyZTEOMAwGA1UEBwwF
RG92ZXIxIjAgBgNVBAoMGUJyYWR5IEdsb2JhbCBIb2xkaW5ncyBMTEMxHjAcBgNV
BAsMFUJyYWR5IEdsb2JhbCBIb2xkaW5nczEUMBIGA1UEAwwLQkdIIFJvb3QgQ0Ex
LjAsBgkqhkiG9w0BCQEWH2NvbnRhY3RAYnJhZHlnbG9iYWxob2xkaW5ncy5jb20w
HhcNMjMwMzI3MTU1ODUxWhcNMzMwMzI0MTU1ODUxWjCBlTELMAkGA1UEBhMCVVMx
ETAPBgNVBAgMCE1hcnlsYW5kMRQwEgYDVQQHDAtHbGVuIEJ1cm5pZTEiMCAGA1UE
CgwZQnJhZHkgR2xvYmFsIEhvbGRpbmdzIExMQzEbMBkGA1UECwwSUmFuY2hlciBG
ZWRlcmFsIElPMRwwGgYDVQQDDBMqLnJhbmNoZXJmZWRlcmFsLmlvMIICIjANBgkq
hkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAzzttaFbT0YrZhBHjj308pqbCGHtnw8gm
wUcOHS7kg+pyMuCLKrz3AMPdzxtAXp7zl69bjwFSGLjB3YJ49Ju6ytZEUCsjcnuq
twu9Kzh2ZWd/XrQ2EEtUrFkrCB7YP732APUQ0FkuiK4f1Wxm+U/wzXLxTQvvOrqW
bqfRd/ITmEm1x1fcutWonzqW+e9l+oBkqxUuIsIr6Qbz7HqeUpzK82R7Cm4an3Ia
r113KD1uv9PQDkLuiMd4ZtJfcmwyiXD5I3m9IH6y5FSdvVMGCk87ck4heebvqJZm
BI/LJH7cAPMhXrqcLYAjy0f07CHVZxsKrSizQEk70HxsCVh3vAkfP9dh2ZvPwgWn
JDxjOdv5LxN+EFRXk9SGK6aA76JPF7a/8MY31foUO5/vPZ/dObiR2F659fTDRm8X
6yOcyEmDqrbWKNBUAS6q1IHo4eosUhf2qd/9VFLjvItfg51pi4XL9MDH7aVIZJa/
rPLw0eWTMZqfrZ188fUqR95h5G3du4uQNntyz4ACQrAlOeD31iUhw1atXbRuWekB
WXZ6gbYqVBOh6yn2hk0+FTx+i64PXFsEljsJ2jwqReIE0sFn1hMw7bU0xMGjh5js
lWoOjfEcqJ+YPFSjCdyBsfPkTtVJqy5sjNA0DjTRR2kanhOAGIOONWu4mGUWKn8c
cyMvXv5MzJkCAwEAAaOBhTCBgjALBgNVHQ8EBAMCBDAwEwYDVR0lBAwwCgYIKwYB
BQUHAwEwHgYDVR0RBBcwFYITKi5yYW5jaGVyZmVkZXJhbC5pbzAdBgNVHQ4EFgQU
zPyUF9aXBB0TnbLSR2rozSnSsMswHwYDVR0jBBgwFoAUazlWTs2HFt1R+/3R8ncN
STaL6a4wDQYJKoZIhvcNAQELBQADggEBAI8QLtDdhHgfKXViczgVm+defH0/pbYz
1pZGvP7fBoH7ThimPRyuiEq/C/z0Cd7z5INwbytdQ6aTqO4GsD2yk14qhejloNBr
JsRQtnvAClv7/nM8nmeLzYJzP1lJJ0jvSEGxAC/3WN5YSAevv1jJoQI/0xQxsszP
bhqSsVFxYmfz8ZnauAyRpIqVA8ZM6/dgwFSP96/FI3oBlN5fdOA/1uTpJwJnkyDI
/XuNtj3Ltp92BF/Izt3iCg641I5YcDF4E1nfOdhDc6OeTCG58ijKmzDVwp6Y3j2U
kvlnKmDECQw6ES0pcLakLcS70IcrWbaEKmqfl1OE+b/c4swGuHianhU=
-----END CERTIFICATE-----
EOF
cp wildcard.rancherfederal.io.pem tls.crt

cat <<EOF >> wildcard.rancherfederal.io.key
-----BEGIN PRIVATE KEY-----
MIIJQQIBADANBgkqhkiG9w0BAQEFAASCCSswggknAgEAAoICAQDPO21oVtPRitmE
EeOPfTympsIYe2fDyCbBRw4dLuSD6nIy4IsqvPcAw93PG0BenvOXr1uPAVIYuMHd
gnj0m7rK1kRQKyNye6q3C70rOHZlZ39etDYQS1SsWSsIHtg/vfYA9RDQWS6Irh/V
bGb5T/DNcvFNC+86upZup9F38hOYSbXHV9y61aifOpb572X6gGSrFS4iwivpBvPs
ep5SnMrzZHsKbhqfchqvXXcoPW6/09AOQu6Ix3hm0l9ybDKJcPkjeb0gfrLkVJ29
UwYKTztyTiF55u+olmYEj8skftwA8yFeupwtgCPLR/TsIdVnGwqtKLNASTvQfGwJ
WHe8CR8/12HZm8/CBackPGM52/kvE34QVFeT1IYrpoDvok8Xtr/wxjfV+hQ7n+89
n905uJHYXrn19MNGbxfrI5zISYOqttYo0FQBLqrUgejh6ixSF/ap3/1UUuO8i1+D
nWmLhcv0wMftpUhklr+s8vDR5ZMxmp+tnXzx9SpH3mHkbd27i5A2e3LPgAJCsCU5
4PfWJSHDVq1dtG5Z6QFZdnqBtipUE6HrKfaGTT4VPH6Lrg9cWwSWOwnaPCpF4gTS
wWfWEzDttTTEwaOHmOyVag6N8Ryon5g8VKMJ3IGx8+RO1UmrLmyM0DQONNFHaRqe
E4AYg441a7iYZRYqfxxzIy9e/kzMmQIDAQABAoICADTNpKwQa7qZ0aDYWg6Gz7x7
AzvvvdniFxXqgAsplqqSQ3T5SBykt59nSQ5rmDRD9jexQ/glUwDfmu5RP3a8c5UZ
kaCHzWlvX2lywUnRAkIGZCsCakAuoa2krtVL3rgnNBa8WwNrpfLHw27DR13BY89F
uXxzTQq+3nPlqPcSJLIKHhpkJecpZ+TirfOTb32r13rMU8whg8TFs8OO3uaX8xKf
iMZ4laoJDgmfHCyRsrWISBxKK7OIeAJjGlTygtIIikLi0zEDd5u8f9Ds5b4cwD34
8Ii6MljXsbj51r4+4NoRGXCkxgTGANjcRekhGdpCxq6mjz4TKv2Npo2fECtGe8J4
Ij7E3rlDeZ5LWVEd+vnpYIqNUvxSIfl3gM+/k+0pasPm0mNSa0Fea5TVsrVW5Pgt
dETwB6r/ZHzbT4Y9ceKcz4lw2vfntc8+vWNhAGt9laFMx4803V1epBRBtr1ZE6Em
j6A2BSwM6fHa8Wmol3K3J3xl8uMX3YcWlYaO5t12zx7s+K2S76AdRZoKOoQmXG3P
fpuRkrpAxM9vziP68B+iVM7HiWVFRChcL/bo8SV3PRlI+3OoN6PT6IRJdIHikdxP
W44bCOh1SkPA2uSwmY2ez6/kuoq8GEpkzkjiIJTfiUAtJh/wZnybFzjN+/E9AzR6
UqhFaxRSsyADxwetInP9AoIBAQDxWgP/BYZQjlMXbzrByJD9Q63mOWN5od8WtbHy
D95qS2rLwR9Mvr+N/R4YM4vd1KGJwRuFNfZ0LVganxfWY3Z5PdvCNcRmVQq1cKoM
Xk6J0iygjRanarTAKxu/JIAp3ZtBUVQXmetTzcADLi8y2tFWBVkSL9QjqtzkuKNh
fHB7HOY9FqkExMehLSrZ9UhtfVMzudb8Ug2go2e33GovKGGogrVdhf7ptcvP7nO2
+gVcu7ImczxJH7t1KCpEydFS8xjHFv8bsFWkE8LVX8k/VGf5QaP7cL8akyhb4Qqq
seIWjYO/iwlZq2zLp94PHJg1drqDeTCydj7K5UaXVjlUJRyfAoIBAQDbz0hXpJhr
+TG1zKL2f+hDuKkyWjJsPboDLjWSokbQjqA66F6zHrKS+zm1sPXd5HVjYiKuw8Pc
UzMWC+hEhRd0fYPirmQ7dFOrrw2AwM6W0U8c3vDfwWqU9ZlnSqeAKCQlS0uawJu4
/POXdDJboJwEHuXaXs6UfTYF1twD8SGlmtqwk5OANEBIqT2163Hw2JLYbKo8kyQM
aMuETsbEMGd5LEkAi2AGn9rrFBnaK2yqFREO47fomMJD1ThQ0mWXTF3fO5El/PP1
NCzIPmeOOkaPyGF9ia7HGQKYFDnvTb2ITSwidDxMK90DVfYhOpDkoMklD4zbba/7
DL6Fwu03VFPHAoIBAGaGlqv+7M/LpgCOf6dSTEVKOtVSC6/f06USCkWJ+DGvV+62
W1V+smDe5aniO8hAS175aXdtNQSlPogQjU/FcM6QOIqHzKar+aCZ+6LFbRee8NZD
GRyFd8MqjN7l4ovmV82nftGH0TAId0jilapEyiiAnRXcu4FrU+rVhJIlCqNB44yP
07zy2trdFRcB24KnenC+wVTuhlt3DthMCc9+l/29iM3x3hfp4mqyIPXZv+1kzokG
6tUlZbyfE1WlZgaWvi/U1QouHjNVMa7ywcrlUEXSXJazjnr7iGl/b8iTSDfMZes4
ZQBykgTxiqNgwkfz58dx8/3bvVDzlMk1F6VnHoECggEAFa/T0WHZ7/08HFW+Vle0
UMotV1xy0R8d9SZf/sGn/vezc1xty3ph4AKNZRG6kFP0CQQrq9aAwoIq7ifqmKgQ
8ltX4cuW9A68GppA2M0tFNA93/lXBpyMqXm50ukYsZpERrGxGema85txZSX/ue6U
tgteXjcwZpIb/GOAfZsS2MX4gadtzB5boU+hWQuLyFl104iVGzjhO6AzRDCJh93G
t7vY0AbwSHcJIFxxWIckR3ugnTl2capwsESfM8ouX8kXEelMntTgNPca2/7cNLon
MBRzGfG1nssm6F5GgQfIhWQn0JZrRJCnU6bti8W9efErJ07rdNLTpA9T1NqwkN7v
DQKCAQAlqwgNZ+21P7CldWBWqn2n+sb8cy1+97MFaDjDEkOp5te3tHP5Tgw3EUnQ
6TRZYicvX9qSxUp2JeDcSbursmWxi2arpi+7lNAwiZD7LJly2IIP9FIkQ9Ss70XW
skAtOJuJwjXJUDyPzblLn1AnHEreR7MUvtoFJj1/+0Ic5yvq/E3luTTrhh38JJGh
cerTlMruTJAZKj27j/swl/y+btrlUNmrcXPCJuDK0yEkoAQQTi550aftPTv0Ta3d
ihr8tzNhkcU87YGzppdhUIJG7WtjTqMkwN8spJiZarhU3UhiX5BOgXPL+otUY2Ga
3zZK5GYY+5PDxc2ZzaqqoenynMHH
-----END PRIVATE KEY-----
EOF
cp wildcard.rancherfederal.io.key tls.key

### Configure AWS CLI
mkdir -p ~/.aws
  cat << EOF > ~/.aws/config
[default]
region = us-east-1
EOF

  cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = AKIARVNJD56435XV254U
aws_secret_access_key = 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
EOF

### Install Rancher Apps
cd /opt/rancher/certs
kubectl create secret generic tls-ca  --from-file=cacerts.pem=/opt/rancher/certs/ca.pem
kubectl create secret tls tls-certs --cert=tls.crt --key=tls.key

### Install Longhorn
kubectl create namespace longhorn-system

kubectl -n longhorn-system create secret generic tls-ca  --from-file=cacerts.pem=/opt/rancher/certs/ca.pem
kubectl -n longhorn-system create secret tls tls-longhorn-certs --cert=tls.crt --key=tls.key

helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --set ingress.enabled=true --set ingress.tls=true --set ingress.secureBackends=true --set ingress.tlsSecret=tls-longhorn-certs --set global.cattle.systemDefaultRegistry=rgcrprod.azurecr.us --set ingress.host=longhorn.rancherfederal.io

kubectl apply -f https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/longhorn-volume.yaml
kubectl apply -f https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/longhorn-volume-test.yaml


### Install Rancher
kubectl create namespace cattle-system

kubectl -n cattle-system create secret generic tls-ca  --from-file=cacerts.pem=/opt/rancher/certs/ca.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress  --cert=tls.crt --key=tls.key

helm upgrade -i rancher carbide-charts/rancher --namespace cattle-system --set bootstrapPassword=Pa22word --set replicas=3 --set auditLog.level=2 --set auditLog.destination=hostPath --set privateCA=true --set ingress.tls.source=secret --set systemDefaultRegistry=rgcrprod.azurecr.us --set rancherImage=rgcrprod.azurecr.us/rancher/rancher --set "carbide.whitelabel.image=rgcrprod.azurecr.us/carbide/carbide-whitelabel" --set hostname=rancher.rancherfederal.io 


### Install Neuvector
kubectl create namespace cattle-neuvector-system

kubectl -n cattle-neuvector-system create secret generic tls-ca  --from-file=cacerts.pem=/opt/rancher/certs/ca.pem
kubectl -n cattle-neuvector-system create secret tls tls-neuvector-certs  --cert=tls.crt --key=tls.key

helm upgrade -i neuvector neuvector/core --namespace cattle-neuvector-system --set imagePullSecrets=regsecret --set k3s.enabled=true --set k3s.runtimePath=/run/k3s/containerd/containerd.sock --set manager.ingress.enabled=true --set manager.ingress.tls=true --set manager.ingress.secretName=tls-neuvector-certs --set manager.svc.type=ClusterIP --set controller.pvc.enabled=true --set controller.pvc.capacity=1Gi --set controller.image.repository=neuvector/controller --set enforcer.image.repository=neuvector/enforcer --set manager.image.repository=neuvector/manager --set cve.updater.image.repository=neuvector/updater --set registry=rgcrprod.azurecr.us --set manager.ingress.host=neuvector.rancherfederal.io

### Install Harbor
kubectl create namespace harbor

kubectl -n harbor create secret generic tls-ca  --from-file=cacerts.pem=/opt/rancher/certs/ca.pem
kubectl -n harbor create secret tls tls-harbor-certs --cert=tls.crt --key=tls.key

helm upgrade -i harbor harbor/harbor --namespace harbor --set expose.tls.certSource=secret --set expose.tls.secret.secretName=tls-harbor-certs --set notary.enabled=false --set expose.tls.auto.commonName=harbor.rancherfederal.io --set expose.ingress.hosts.core=harbor.rancherfederal.io --set persistence.enabled=true --set persistence.persistentVolumeClaim.registry.size=100Gi --set harborAdminPassword=Pa22word --set externalURL=https://harbor.rancherfederal.io


### Install Carbide
mkdir -p /opt/rancher/carbide
cd /opt/rancher/carbide

cat << EOF >> /opt/rancher/carbide/ssf-key.pub
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE5zlXeLmRxBHbVmDRZpnCFdzKhyKO
tCAZva7CLlk/6gxvCM0QkIKznfaGTRMMYTaHMdQSau6yulDLlpokA++i8Q==
-----END PUBLIC KEY-----
EOF

chmod 755 /opt/rancher/carbide/ssf-key.pub

cat << EOF >> ~/.bashrc
export PATH=$PATH:/usr/local/bin
export KEY=/opt/rancher/carbide/ssf-key.pub
EOF
source ~/.bashrc


cosign login -u zack-brady-read-token -p bD7Ov85FZW/E6s+j+DbPFa+ci6py6o+AQuxUzecmf++ACRCO8P1z rgcrprod.azurecr.us


cat << EOF >> /etc/rancher/rke2/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - "https://rgcrprod.azurecr.us"

configs:
  "rgcrprod.azurecr.us":
    auth:
      username: zack-brady-read-token
      password: bD7Ov85FZW/E6s+j+DbPFa+ci6py6o+AQuxUzecmf++ACRCO8P1z
EOF

cat << EOF >> /etc/rancher/rke2/config.yaml
system-default-registry: rgcrprod.azurecr.us
EOF

kubectl create secret docker-registry docker-registry-secret --docker-username=zack-brady-read-token --docker-password=bD7Ov85FZW/E6s+j+DbPFa+ci6py6o+AQuxUzecmf++ACRCO8P1z --docker-server=rgcrprod.azurecr.us

kubectl create namespace carbide-docs-system 
kubectl create namespace carbide-stigatron-system

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: stigatron-license
  namespace: carbide-stigatron-system
type: Opaque
stringData:
  license: eyJpZCI6Ijk0MGY5MjJlLWM5ZTgtNDBjNi04YjlmLTMxZmY1Zjg4OTM4MyIsImxpY2Vuc2VlIjoiemFjay1icmFkeSIsIm1ldGFkYXRhIjp7fSwiZ3JhbnRzIjp7ImNvbXBsaWFuY2UuY2F0dGxlLmlvL3N0aWdhdHJvbiI6MTAwfSwibm90QmVmb3JlIjoiMjAyMy0wMi0yN1QwMDowMDowMFoiLCJub3RBZnRlciI6IjIwMjQtMDItMjdUMDA6MDA6MDBaIn0=.B37WHFrm9ZLKdWP/OUTpGc8T3anD0boR33kUgC9jRuAeEYEniuAGtpsoI3Op1nw4hRZy2yEAQC+WBYUocTSehLKyp66IFdyMfuI6A617KMOPwtXNxF+Wqjm5ZghqTI7myxTz26doOqmPctXu5TQmD3o2QQcYBZ/5ma0IEAOtdVNbr+An2AfVd3VmE5UsDoXpxAsS7fxgoDNbJuCN5O8WWmu51fn9OekHVIfgJPRvDkla4JvvPF3i7kqkOZ/SZjjjDvnITO5EokKCpae2eyjef4leXyAZb2K5PXrEAApSAcTP4nvH1D6WxUgN/9f6/0eVxiQIa9q9nE3OPKYEy/swTQ==
EOF

helm upgrade -i airgapped-docs carbide-charts/airgapped-docs -n carbide-docs-system --set global.cattle.systemDefaultRegistry=harbor.rancherfederal.io

helm upgrade -i stigatron-ui carbide-charts/stigatron-ui -n carbide-stigatron-system --set global.cattle.systemDefaultRegistry=harbor.rancherfederal.io

helm upgrade -i stigatron carbide-charts/stigatron -n carbide-stigatron-system --set global.cattle.systemDefaultRegistry=harbor.rancherfederal.io --set heimdall2.heimdall.rcidf.registry=harbor.rancherfederal.io --set heimdall2.global.cattle.systemDefaultRegistry=harbor.rancherfederal.io