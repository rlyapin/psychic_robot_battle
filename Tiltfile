docker_build('frontend-image', 'frontend')
k8s_yaml('kubernetes/frontend.yaml')
k8s_resource('frontend', port_forwards='3000')
