load('../bazel.star', 'bazel_k8s', 'bazel_build')

def get_services_to_run(to_run):
  all_go_service_collections = [
    {
      'name': 'weather',
      'services': [
        'weather-sensor',
        'weather-backend',
        'weather-frontend',
      ]
    },
  ]

  go_services=[]
  go_service_collections=[]

  for tr in to_run:
    for c in all_go_service_collections:
      svcs_to_append=[]
      for s in c['services']:
        if tr == s or tr == '*':
          svcs_to_append.append(s)
      go_service_collections.append({
        'name': c['name'],
        'services': svcs_to_append
      })

  return go_services_legacy_path, go_services, go_service_collections

def run_services(services, repo_root_relative_service_path):
  for svc in services:
    k8s_yaml(bazel_k8s(':{}'.format(svc), svc))
    bazel_build(
      '{}'.format(svc),
      "//{}/{}:image".format(repo_root_relative_service_path, svc),
      svc,
      repo_root_relative_service_path
    )
