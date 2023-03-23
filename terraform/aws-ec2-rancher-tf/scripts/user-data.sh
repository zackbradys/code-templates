#!/bin/bash

set -ebpf

cat << EOF > /opt/user-data.txt
verify user-data injection into /opt
EOF