#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Usage: $0 <pod> <container>"
    exit 1
fi

pod=$1
shift
container=$1

kubectl exec $pod --stdin --tty -c $container /bin/bash
