#!/bin/bash

yum install -y docker

systemctl enable docker
systemctl start docker
