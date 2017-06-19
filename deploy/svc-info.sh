#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <pod>"
    exit 1
fi

service=$1
kubectl describe services $service
