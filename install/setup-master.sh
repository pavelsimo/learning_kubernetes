#!/bin/bash

RUNDIR=$(dirname $0)

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must be run with root privileges."
    exit 1
fi

###############################################################################
# Installing prerequisites
###############################################################################

# install ntpd
$RUNDIR/install-ntpd.sh

# install kubernetes repo
$RUNDIR/install-k8s-repo.sh

# install etcd
$RUNDIR/install-etcd.sh

# install kubernetes
$RUNDIR/install-k8s.sh

###############################################################################
# Configuring kubernetes
###############################################################################
cp /etc/kubernetes/config /etc/kubernetes/config.bak
cat > /etc/kubernetes/config <<EOF
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=0"
KUBE_ALLOW_PRIV="--allow-privileged=false"
KUBE_MASTER="--master=http://$HOSTNAME:8080"
KUBE_ETCD_SERVERS="--etcd-servers=http://$HOSTNAME:2379"
EOF

###############################################################################
# Configuring kubernetes apiserver
###############################################################################
cp /etc/kubernetes/apiserver /etc/kubernetes/apiserver.bak
cat > /etc/kubernetes/apiserver <<EOF
KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet-port=10250"
KUBE_ETCD_SERVERS="--etcd-servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_API_ARGS=""
EOF

###############################################################################
# Configuring the services 
###############################################################################
systemctl enable kube-apiserver kube-controller-manager kube-scheduler
systemctl start kube-apiserver kube-controller-manager kube-scheduler
