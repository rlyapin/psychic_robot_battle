#!/bin/bash

# Following instructions from https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
# And https://github.com/containerd/containerd/blob/main/docs/getting-started.md

# Installing containerd
wget https://github.com/containerd/containerd/releases/download/v1.6.8/containerd-1.6.8-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.6.8-linux-amd64.tar.gz

wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system/
cp containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

# Installing runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

# Installing CNI plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz

# Creating containerd config
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

# Configuring the systemd cgroup driver
sed -i -e 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
