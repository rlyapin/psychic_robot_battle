#!/bin/bash

# kubeadm init --config kubeadm-config.yaml
kubeadm init --cri-socket "unix:///var/run/cri-dockerd.sock"
export KUBECONFIG=/etc/kubernetes/admin.conf
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > ~/.bash_profile
# https://stackoverflow.com/questions/48785324/source-command-in-shell-script-not-working
# . ~/.bash_profile

# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/tigera-operator.yaml
# curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/custom-resources.yaml -O
# kubectl create -f custom-resources.yaml

# curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/calico.yaml -O
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/calico.yaml
