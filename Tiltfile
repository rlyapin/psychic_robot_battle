docker_build('frontend-image', 'frontend')
docker_build('psychic-image', 'psychic')

k8s_yaml('kubernetes/frontend.yaml')
k8s_yaml('kubernetes/psychic.yaml')

k8s_resource('frontend', port_forwards='3000')
k8s_resource('psychic', port_forwards='8080')