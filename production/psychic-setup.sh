#!/bin/bash

# References:
# https://docs.docker.com/registry/deploying/
docker run -d -p 5000:5000 --restart=always --name registry registry:2
# /etc/docker/daemon.json
# {
#   "insecure-registries" : ["myregistrydomain.com:5000"]
# }
# systemctl restart docker

# docker build psychic_robot_battle/timescaledb -t timescaledb-image
# docker build psychic_robot_battle/redis -t redis-image
# docker build psychic_robot_battle/airflow -t airflow-image # -t airflow-worker-image
# docker build psychic_robot_battle/frontend -t frontend-image
# docker build psychic_robot_battle/psychic -t psychic-image

# docker tag timescaledb-image localhost:5000/timescaledb-image
# docker tag redis-image localhost:5000/redis-image
# docker tag frontend-image localhost:5000/frontend-image
# docker tag psychic-image localhost:5000/psychic-image
# docker tag airflow-image localhost:5000/airflow-image

docker build psychic_robot_battle/timescaledb -t localhost:5000/timescaledb-image
docker build psychic_robot_battle/redis -t localhost:5000/redis-image
docker build psychic_robot_battle/airflow -t localhost:5000/airflow-image
docker build psychic_robot_battle/frontend -t localhost:5000/frontend-image
docker build psychic_robot_battle/psychic -t localhost:5000/psychic-image


docker push localhost:5000/timescaledb-image
docker push localhost:5000/redis-image
docker push localhost:5000/airflow-image
docker push localhost:5000/frontend-image
docker push localhost:5000/psychic-image

kubectl apply -f psychic_robot_battle/kubernetes/secrets/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/secrets/airflow.yaml
kubectl apply -f psychic_robot_battle/kubernetes/secrets/redis.yaml

kubectl apply -f psychic_robot_battle/kubernetes/volumes/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/volumes/redis.yaml

kubectl apply -f psychic_robot_battle/kubernetes/roles/airflow.yaml

sed -i -e 's/timescaledb-image/10.0.0.2:5000/timescaledb-image/g' psychic_robot_battle/kubernetes/services/timescaledb.yaml
sed -i -e 's/redis-image/10.0.0.2:5000/redis-image/g' psychic_robot_battle/kubernetes/services/redis.yaml
sed -i -e 's/psychic-image/10.0.0.2:5000/psychic-image/g' psychic_robot_battle/kubernetes/services/psychic.yaml
sed -i -e 's/frontend-image/10.0.0.2:5000/frontend-image/g' psychic_robot_battle/kubernetes/services/frontend.yaml
sed -i -e 's/airflow-image/10.0.0.2:5000/airflow-image/g' psychic_robot_battle/kubernetes/services/airflow.yaml
sed -i -e 's/airflow-worker-image/10.0.0.2:5000/airflow-image/g' psychic_robot_battle/airflow/pod_template_file.yaml

kubectl apply -f psychic_robot_battle/kubernetes/services/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/redis.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/psychic.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/frontend.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/airflow.yaml
