#!/bin/bash

# Loading external ip for cluster
external_ip=$1

# Following instructions from https://docs.docker.com/engine/install/ubuntu/
# Install docker-ce
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin << 'EOF'
Y
EOF

# Following instruction from https://github.com/Mirantis/cri-dockerd
# Install go
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
./installer_linux
source ~/.bash_profile

# Install cri-dockerd
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
cd ../

systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket

# https://stackoverflow.com/questions/43794169/docker-change-cgroup-driver-to-systemd
# Extra step to prepare for local docker registry: https://docs.docker.com/registry/insecure/
# localhost:31000 = NodeIP:NodePort for deployed k8s NodePort registry service
echo "{ \"insecure-registries\" : [\"localhost:31000\"], \"exec-opts\": [\"native.cgroupdriver=systemd\"] }" > /etc/docker/daemon.json
systemctl restart docker

# Following instructions from https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

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
