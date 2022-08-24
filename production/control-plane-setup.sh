#!/bin/bash

# kubeadm init --config kubeadm-config.yaml
kubeadm init --cri-socket "unix:///var/run/cri-dockerd.sock"
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > ~/.bash_profile
source ~/.bash_profile

# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/tigera-operator.yaml
# curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/custom-resources.yaml -O
# kubectl create -f custom-resources.yaml

# curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/calico.yaml -O
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/calico.yaml
source ~/.bash_profile
