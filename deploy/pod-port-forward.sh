#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Usage: $0 <pod> <host_port> <remote_port>"
    exit 1
fi

pod=$1
shift
host_port=$1
shift
remote_port=$1


kubectl port-forward $pod $host_port:$remote_port
