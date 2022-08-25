#!/bin/bash

kubeadm init --cri-socket "unix:///var/run/cri-dockerd.sock"
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > ~/.bash_profile
. ~/.bash_profile
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/calico.yaml
