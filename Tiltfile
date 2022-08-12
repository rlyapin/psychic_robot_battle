docker_build('frontend-image', 'frontend')
docker_build('psychic-image', 'psychic')
docker_build('timescaledb-image', 'timescaledb')
docker_build('airflow-image', 'airflow', extra_tag=['latest'])

k8s_yaml('kubernetes/secrets/timescaledb.yaml')
k8s_yaml('kubernetes/secrets/pgadmin.yaml')
k8s_yaml('kubernetes/secrets/airflow.yaml')

k8s_yaml('kubernetes/frontend.yaml')
k8s_yaml('kubernetes/psychic.yaml')
k8s_yaml('kubernetes/timescaledb.yaml')
k8s_yaml('kubernetes/pgadmin.yaml')
k8s_yaml('kubernetes/airflow.yaml')

k8s_resource('frontend', port_forwards='3000')
k8s_resource('psychic', port_forwards='8080')
k8s_resource('pgadmin', port_forwards='30165:80')
k8s_resource('airflow', port_forwards='8000')
