
Command History
===============

Installing NTP Server

    yum -y install ntp
    systemctl enable ntpd && systemctl start ntpd

Check iptables and firewalld are diabled

    systemctl status iptables
    systemctl status firewalld

Installing Kubernetes and Docker

    yum install -y --enablerepo=virt7-docker-common-release kubernetes docker

Installing etcd (master only)

    yum install -y --enablerepo=virt7-docker-common-release etcd

Configure the Kubernetes Master

    vi /etc/kubernetes/config
    KUBE_MASTER="--master=http://master:8080"   
    KUBE_ETCD_SERVERS="--etcd-servers=http://master:2379" 

Configure etcd

    vi /etc/etcd/etcd.conf
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
    ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"

Configure Kubernetes API Server

    vi /etc/kubernetes/apiserver
    KUBE_API_ADDRESS="--address=0.0.0.0"
    KUBE_API_PORT="--port=8080"
    KUBELET_PORT="--kubelet-port=10250"
    # KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

Starting the etcd and Kubernetes services (master)

    systemctl enable etcd kube-apiserver kube-controller-manager kube-scheduler
    systemctl start etcd kube-apiserver kube-controller-manager kube-scheduler

Configure the Kubernete Master (all nodes)

    vi /etc/kubernetes/config
    KUBE_ETCD_SERVERS="--etcd-servers=http://master:2379"

Configure the kubelet (all nodes)

    vi /etc/kubernetes/kubelet
    KUBELET_ADDRESS="--address=0.0.0.0"
    KUBELET_PORT="--port=10250"
    KUBELET_HOSTNAME="--hostname-override=node1"
    KUBELET_API_SERVER="--api-servers=http://master:8080"
    # KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"

Starting kube-proxy, kubelete and docker (all nodes)

    systemctl enable kube-proxy kubelet docker
    systemctl start kube-proxy kubelet docker
    systemctl status kube-proxy kubelet docker | grep "(running)" | wc -l

Verify docker is running

    docker images
    docker --version

Pull docker hello-world image

    docker pull hello-world
    docker run hello-world

See nodes register to the kubernetes cluster

    kubectl get nodes
    # docs
    man kubectl-get

See nodes information

    kubectl describe nodes

Query nodes information

    ** TODO: Copy commands from LA: Kubectl Exploring our Environment 7:21

See pods

    kubectl get pods
