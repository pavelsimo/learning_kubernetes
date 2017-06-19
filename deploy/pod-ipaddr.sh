#!/bin/bash
# http://rafabene.com/2015/11/11/how-expose-kubernetes-services/

if [ $# -ne 1 ]
then
    echo "Usage: $0 <pod>"
    exit 1
fi

echo $(kubectl get -o template po $1 --template={{.status.podIP}})
