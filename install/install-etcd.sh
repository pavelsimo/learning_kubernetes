#!/bin/bash

yum install -y etcd

cp /etc/etcd/etcd.conf /etc/etcd/etcd.conf.bak
cat > /etc/etcd/etcd.conf <<EOF
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
EOF

systemctl enable etcd
systemctl start etcd
