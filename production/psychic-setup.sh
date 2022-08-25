#!/bin/bash

kubectl apply -f psychic_robot_battle/kubernetes/services/registry.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments

docker build psychic_robot_battle/timescaledb -t localhost:31000/timescaledb-image
docker build psychic_robot_battle/redis -t localhost:31000/redis-image
docker build psychic_robot_battle/airflow -t localhost:31000/airflow-image -t localhost:31000/airflow-worker-image
docker build psychic_robot_battle/frontend -t localhost:31000/frontend-image
docker build psychic_robot_battle/psychic -t localhost:31000/psychic-image

docker push localhost:31000/timescaledb-image
docker push localhost:31000/redis-image
docker push localhost:31000/airflow-image
docker push localhost:31000/frontend-image
docker push localhost:31000/psychic-image

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
sed -i -e 's=airflow-worker-image=localhost:31000/airflow-worker-image=g' psychic_robot_battle/airflow/pod_template_file.yaml

kubectl apply -f psychic_robot_battle/kubernetes/services/timescaledb.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/redis.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments

kubectl apply -f psychic_robot_battle/kubernetes/services/airflow.yaml
kubectl apply -f psychic_robot_battle/kubernetes/services/psychic.yaml
kubectl wait --for=condition=available --timeout=300s --all deployments

kubectl apply -f psychic_robot_battle/kubernetes/services/frontend.yaml
kubectl wait --for=condition=available --timeout=60s --all deployments
