#!/bin/bash

yum -y install ntp
systemctl enable ntpd 
systemctl start ntpd
