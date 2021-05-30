load('ext://helm_remote', 'helm_remote')

def get_external_services_to_run(to_run):
  all_external_services = [
    'redis',
  ]

  external_services=[]

  for tr in to_run:
    for s in all_external_services:
      if tr == s or tr == '*':
        external_services.append(s)

  return external_services

def run_external_services(services):
  for svc in services:
    if svc == 'redis':
      k8s_yaml('k8s/redis_deployment.yaml')
      k8s_resource('redis', port_forwards='6388:6379')
