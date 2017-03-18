#!/bin/bash

cp /etc/hosts /etc/hosts.bak
cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.10   master
10.0.0.11   node1
10.0.0.12   node2
EOF
