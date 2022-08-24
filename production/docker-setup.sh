#!/bin/bash

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

# Extra step to prepare for local docker registry: https://docs.docker.com/registry/insecure/
# https://stackoverflow.com/questions/43794169/docker-change-cgroup-driver-to-systemd
echo "{ \"insecure-registries\" : [\"10.0.0.2:5000\"], \"exec-opts\": [\"native.cgroupdriver=systemd\"] }" > /etc/docker/daemon.json
systemctl restart docker

# Following instructions from:
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md#customizing-containerd
# Creating containerd config
# mkdir -p /etc/containerd
# containerd config default > /etc/containerd/config.toml

# Configuring the systemd cgroup driver
# sed -i -e 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
# sudo systemctl restart containerd
