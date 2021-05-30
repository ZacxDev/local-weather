def load_namespace():
  k8s_yaml('k8s/namespace.yaml')

def load_config_maps():
  k8s_yaml('k8s/config-map/gcp-app-env.yaml')
  k8s_yaml('k8s/config-map/go-gcp-app-env.yaml')
  k8s_yaml('k8s/config-map/go-env.yaml')
  k8s_yaml('k8s/config-map/bugsnag-app-env.yaml')
  k8s_yaml('k8s/config-map/node-app-env.yaml')
  k8s_yaml('k8s/config-map/dev-env.yaml')
  k8s_yaml('k8s/config-map/routing-env.yaml')
  k8s_yaml('k8s/config-map/routing-v1-env.yaml')
  k8s_yaml('k8s/config-map/mysql-app-env.yaml')

