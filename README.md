
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

Configure the etcd server (master only)

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

Deleting a POD

    kubectl delete pod busybox

Obtain POD information

    kubectl describe pod nginx

Query PODs by APP name

    kubectl get pods -l app=myapp_name

Workaround for the GFW (all nodes)

    docker pull docker.io/kubernetes/pause
    # Notice that the version of the pause-amd64 may differ in your version of
    # Kubernetes in this case is version 3.0
    docker tag docker.io/kubernetes/pause gcr.io/google_containers/pause-amd64:3.0

Query Deployments

    kubectl get deployments
    kubectl describe deployments -l app=nginx-deployment-dev

Update a Deployment

    kubectl apply -f nginx-deployment-dev-update.yaml

See Deployment Information

    kubectl describe deployments nginx-deployment-dev

Query the Replication Controller

    kubectl describe replicationcontroller

Get replication controllers

    kubectl get replicationcontroller

Delete Replication Controller

    kubectl delete replicationcontroller nginx

Run a POD on the fly

    kubectl run busybox --image=busybox --restart=Never --tty -i --generator=run-pod/v1

Forward POD port to the MASTER

    # kubernetes will assign a random available port to the nginx service
    # NOTE: nginx is running in port 80
    kubectl port-forward nginx :80 

Delete all pods, deployments and persistent volumes

    kubectl delete deployments --all
    kubectl delete pvc --all
    kubectl get pods | tail -n+2 | cut -d' ' -f1 | xargs kubectl delete pod

Deploy Kubernetes Dashboard

    # 
    # https://kubernetes.io/docs/user-guide/ui/
    # http://localhost:8001/ui
    # 
    kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
    kubectl proxy

Query Services

    kubectl get services

Describe Services

    kubectl describe service nginx-service

Delete Service

    kubectl delete service nginx-service

Run busybox Pod

    kubectl run busybox --generator=run-pod/v1 --image=busybox --restart=Never --tty -i

Create Temporary Pods

    kubectl run mysample --image=latest123/apache

Create Temporary Pods Replicas

    kubectl run myreplicas --image=hello-world --replicas=2 --labels=app=hw,version=1.0
    kubectl run myautoscale --image=latest123/apache --port=80 --labels=app=myautoscale

Execute a Command within a Pod 

    # running the date command
    kubectl exec nginx-pod date

    # checking a configuration file
    kubectl exec nginx-pod cat /etc/nginx/conf.d/default.conf

Login to a Container

    kubectl exec nginx-pod -i -t -- /bin/bash

Query the POD logs

    # https://kubernetes.io/docs/user-guide/kubectl/kubectl_logs/
    
    kubectl logs myapache
    kubectl logs --tail=1 myapache
    
    # logs in the last 24 hours
    kubectl logs --since=24h myapache

    # same as tail -f
    kubectl logs -f myapache

Autoscaling PODS

    # minimum 2 pods, maximum 6 pods
    kubectl autoscale deployment myautoscale --min=2 --max=6

Overwriting the Autoscale rules

    # scaling up
    kubectl scale --current-replicas=2 --replicas=4 deployment/myautoscale

    # scaling down
    kubectl scale --current-replicas=4 --replicas=2 deployment/myautoscale
