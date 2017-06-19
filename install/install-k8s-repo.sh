#!/bin/bash

cat > /etc/yum.repos.d/virt7-docker-common-release.repo <<EOF
[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
enabled=1
EOF
