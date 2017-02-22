
Command History
===============

Installing NTP Server

    yum -y install ntp
    systemctl enable ntpd && systemctl start ntpd

Fixing docker warning ipv4 forwarding is disabled

    vi /etc/sysctl.conf
    net.ipv4.ip_forward=1
    systemctl restart network

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

Creating a simple pod definition for nginx

    apiVersion: v1
    kind: Pod
    metadata: 
        name: nginx
    spec:
        containers:
        - name: nginx
          image: nginx:1.7.9
          ports:
          - containerPort: 80

Creating a POD

    kubectl create -f ./nginx.yaml

Obtain POD information

    kubectl describe pod nginx

Workaround for the GFW (all nodes)

    docker pull docker.io/kubernetes/pause
    # Notice that the version of the pause-amd64 may differ in your version of
    # Kubernetes in this case is version 3.0
    docker tag docker.io/kubernetes/pause gcr.io/google_containers/pause-amd64:3.0

Basic Docker commands

    docker info
    docker version
    
    # location where docker images live
    # /var/lib/docker/image
    # /var/lib/docker/image/devicemapper/imagedb/content/sha256

    # location where docker container lives
    # /var/lib/docker/containers

    # pull ubuntu xenial
    docker pull ubuntu:xenial
    docker pull nginx:latest

    # -i interactive mode
    # -t attached to my terminal (tty)
    docker run -i -t ubuntu:xenial /bin/bash

    # restart docker container
    docker restart awesome_sinoussi

    # inspect images
    docker inspect ubuntu:xenial

    # attach to the container
    docker attach awesome_sinoussi

    # -i interactive mode
    # -t attached to my terminal (tty)
    # -d demonized
    docker run -itd ubuntu:xenial /bin/bash

    # obtain container specific information
    docker inspect reverent_thompson

    # start a container
    docker start focused_kilby

    # stop a container
    docker stop reverent_thompson

    # search docker images
    docker search ubuntu
    docker search training/sinatra

    # remove docker image
    docker rmi training/sinatra
    
Build a docker image

    FROM centos:latest
    MAINTAINER pavel.simo@gmail.com
    RUN useradd -m -s /bin/bash user
    USER user

    docker build -t centos7/nonroot:v1 .
    docker run -it centos7/noroot:v1 /bin/bash

Connect to a container as root

    docker exec -u 0 -it focused_kilby /bin/bash

Running nginx in docker

    docker pull nginx:latest
    docker run -d nginx:latest

    # This way of running redirect the local port 80 to the container port 80
    docker run -d -p 80:80 nginx:latest
    elinks http://172.17.0.3
    
    # host -> 8080, container -> 80
    docker run -d -p 8080:80 nginx:latest
    elinks http://127.0.0.1:8080
    elinks http://172.17.0.3


Checking container logs

    docker logs sharp_elion

