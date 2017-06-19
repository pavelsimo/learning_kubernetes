#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <pod>"
    exit 1
fi

pod=$1
kubectl describe pods $pod
