
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
    yum install -y --enablerepo=virt7-docker-common-release etcd

Configure the Kubernetes Master

    vi /etc/kubernetes/config
    KUBE_MASTER="--master=http://master:8080"   
    KUBE_ETCD_SERVERS="--etcd-servers=http://master:2379" 



