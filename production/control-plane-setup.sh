#!/bin/bash

# pod-network-cidr=10.244.0.0/16 is default for canal and hentzner
kubeadm init --cri-socket="unix:///var/run/cri-dockerd.sock" --pod-network-cidr=10.244.0.0/16
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > ~/.bash_profile
. ~/.bash_profile
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/canal.yaml
