#!/bin/bash

# pod-network-cidr=10.244.0.0/16 is default for canal and hentzner
kubeadm init --cri-socket="unix:///var/run/cri-dockerd.sock" --pod-network-cidr=10.244.0.0/16
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > ~/.bashrc
. ~/.bashrc
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/canal.yaml

join_cmd=`kubeadm token create --print-join-command`
echo "Join command for worker nodes:"
echo "$join_cmd --cri-socket=\"unix:///var/run/cri-dockerd.sock\""

exec bash