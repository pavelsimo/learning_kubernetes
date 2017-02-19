
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
