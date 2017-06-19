#!/bin/bash

yum -y install flannel

cp /etc/sysconfig/flanneld /etc/sysconfig/flanneld.bak
cat > /etc/sysconfig/flanneld <<EOF
FLANNEL_ETCD="http://master:2379"
EOF

systemctl enable flanneld
systemctl start flanneld
