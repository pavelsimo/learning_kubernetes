#!/bin/bash

RUNDIR=$(dirname $0)

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must be run with root privileges."
    exit 1
fi

BIND_ADDRESS=0.0.0.0

###############################################################################
# Install prerequisites
###############################################################################

# install ntpd
$RUNDIR/install-ntpd.sh

# install kubernetes repo
$RUNDIR/install-k8s-repo.sh

# install kubernetes
$RUNDIR/install-k8s.sh

# install docker
$RUNDIR/install-docker.sh

# install flannel
$RUNDIR/install-flannel.sh

###############################################################################
# Configuring the kubelet
###############################################################################
cp /etc/kubernetes/kubelet /etc/kubernetes/kubelet.bak
cat > /etc/kubernetes/kubelet <<EOF
KUBELET_ADDRESS="--address=$BIND_ADDRESS"
KUBELET_PORT="--port=10250"
KUBELET_HOSTNAME="--hostname-override=$HOSTNAME"
KUBELET_API_SERVER="--api-servers=http://master:8080"
KUBELET_ARGS=""
EOF

###############################################################################
# Configuring kubernetes apiserver
###############################################################################
cp /etc/kubernetes/apiserver /etc/kubernetes/apiserver.bak
cat > /etc/kubernetes/apiserver <<EOF
KUBE_API_ADDRESS="--address=$BIND_ADDRESS"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet-port=10250"
KUBE_ETCD_SERVERS="--etcd-servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_API_ARGS=""
EOF

###############################################################################
# Configuring the services
###############################################################################
systemctl enable kube-proxy kubelet
systemctl start kube-proxy kubelet

###############################################################################
# Kubernetes workaround for the GFW 
###############################################################################
docker pull kubernetes/pause
docker tag docker.io/kubernetes/pause gcr.io/google_containers/pause-amd64:3.0
