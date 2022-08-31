#!/bin/bash

# Loading external ip for cluster, email for TLS setup and mode for staging/prod deployment
external_ip=$1
email=$2
deploymode=$3

kubectl apply -f psychic_robot_battle/kubernetes/services/registry.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments

docker build psychic_robot_battle/timescaledb -t localhost:31000/timescaledb-image
docker build psychic_robot_battle/redis -t localhost:31000/redis-image
sed -i -e 's=airflow-worker-image=localhost:31000/airflow-worker-image=g' psychic_robot_battle/airflow/pod_template_file.yaml
docker build psychic_robot_battle/airflow -t localhost:31000/airflow-image -t localhost:31000/airflow-worker-image
docker build psychic_robot_battle/frontend -t localhost:31000/frontend-image
docker build psychic_robot_battle/psychic -t localhost:31000/psychic-image

docker push localhost:31000/timescaledb-image
docker push localhost:31000/redis-image
docker push localhost:31000/airflow-image
docker push localhost:31000/airflow-worker-image
docker push localhost:31000/frontend-image
docker push localhost:31000/psychic-image

awk -i inplace 'BEGIN{"openssl rand -hex 16" | getline pwd}  {sub(/PleaseChangeMe/, pwd ); print}' \
psychic_robot_battle/kubernetes/secrets/timescaledb.yaml \
psychic_robot_battle/kubernetes/secrets/airflow.yaml \
psychic_robot_battle/kubernetes/secrets/redis.yaml
kubectl apply -f psychic_robot_battle/kubernetes/secrets/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/secrets/airflow.yaml
kubectl apply -f psychic_robot_battle/kubernetes/secrets/redis.yaml

sed -i -e 's=4Gi=10Gi=g' psychic_robot_battle/kubernetes/volumes/timescaledb.yaml
sed -i -e 's=1Gi=10Gi=g' psychic_robot_battle/kubernetes/services/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/volumes/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/volumes/redis.yaml

kubectl apply -f psychic_robot_battle/kubernetes/roles/airflow.yaml

sed -i -e 's=timescaledb-image=localhost:31000/timescaledb-image=g' psychic_robot_battle/kubernetes/services/timescaledb.yaml
sed -i -e 's=redis-image=localhost:31000/redis-image=g' psychic_robot_battle/kubernetes/services/redis.yaml
sed -i -e 's=psychic-image=localhost:31000/psychic-image=g' psychic_robot_battle/kubernetes/services/psychic.yaml
sed -i -e 's=frontend-image=localhost:31000/frontend-image=g' psychic_robot_battle/kubernetes/services/frontend.yaml
sed -i -e 's=airflow-image=localhost:31000/airflow-image=g' psychic_robot_battle/kubernetes/services/airflow.yaml

kubectl apply -f psychic_robot_battle/kubernetes/services/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/redis.yaml
kubectl wait pods --selector app=timescaledb --for condition=Ready
kubectl wait pods --selector app=redis --for condition=Ready

kubectl apply -f psychic_robot_battle/kubernetes/services/airflow.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/psychic.yaml
kubectl wait --for=condition=available --timeout=300s --all deployments

kubectl apply -f psychic_robot_battle/kubernetes/services/frontend.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments

# Setting up certificate management as in https://cert-manager.io/docs/tutorials/acme/nginx-ingress/
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments --all-namespaces
sed -i -e "s=PleaseChangeMe=$email=g" psychic_robot_battle/kubernetes/ingress/letsencrypt.yaml
kubectl apply -f psychic_robot_battle/kubernetes/ingress/letsencrypt.yaml

# Following https://metallb.universe.tf/installation/
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.4/config/manifests/metallb-native.yaml
kubectl wait --for=condition=ready pod -l app=metallb -n metallb-system
sed -i -e "s=EXTERNAL_IP=$external_ip=g" psychic_robot_battle/kubernetes/ingress/metallb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/ingress/metallb.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=ingress-nginx -l app.kubernetes.io/component=controller -n ingress-nginx
sed -i -e "s=DEPLOYMODE=$deploymode=g" psychic_robot_battle/kubernetes/ingress/frontend.yaml
kubectl apply -f psychic_robot_battle/kubernetes/ingress/frontend.yaml
