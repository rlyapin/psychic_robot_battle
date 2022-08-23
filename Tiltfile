docker_build('frontend-image', 'frontend')
docker_build('psychic-image', 'psychic')
docker_build('timescaledb-image', 'timescaledb')
docker_build('airflow-image', 'airflow', extra_tag=['airflow-worker-image'])
docker_build('redis-image', 'redis')

k8s_yaml('kubernetes/secrets/timescaledb.yaml')
k8s_yaml('kubernetes/secrets/pgadmin.yaml')
k8s_yaml('kubernetes/secrets/airflow.yaml')
k8s_yaml('kubernetes/secrets/redis.yaml')

k8s_yaml('kubernetes/volumes/timescaledb.yaml')
k8s_yaml('kubernetes/volumes/redis.yaml')

k8s_yaml('kubernetes/roles/airflow.yaml')

k8s_yaml('kubernetes/services/timescaledb.yaml')
k8s_yaml('kubernetes/services/psychic.yaml')
k8s_yaml('kubernetes/services/redis.yaml')
k8s_yaml('kubernetes/services/frontend.yaml')
k8s_yaml('kubernetes/services/pgadmin.yaml')
k8s_yaml('kubernetes/services/airflow.yaml')

k8s_resource('frontend', port_forwards='3000')
k8s_resource('psychic', port_forwards='8080')
k8s_resource('pgadmin', port_forwards='30165:80')
k8s_resource('airflow', port_forwards='8000')
k8s_resource('redis', port_forwards='6379')
