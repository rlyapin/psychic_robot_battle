#!/bin/bash

external_ip=$1

# Setting persistent floating ip as advised in https://community.hetzner.com/tutorials/install-kubernetes-cluster
# Using recent instructions from https://docs.hetzner.com/cloud/floating-ips/persistent-configuration#ubuntu-2004
cat > /etc/netplan/60-floating-ip.yaml <<EOF
network:
   version: 2
   renderer: networkd
   ethernets:
     eth0:
       addresses:
       - $external_ip/32
EOF
sudo netplan apply
