i# sync_path returns a list which contains full path in local and in container
# for given api.
def sync_path(apiname):
  list=['{}/'+apiname,'/go/{}/'+apiname]
  return [n.format('go') for n in list]

# sync_steps return synchronization steps for container live update.
def sync_steps(pkgs):
  steps = []
  for p in pkgs:
    src, dst = sync_path(p)
    steps.append(sync(src,dst))

  return steps

def pref(repo_root_relative_path, suffix):
  return '{}/{}'.format(repo_root_relative_path, suffix)

def dep_list(repo_root_relative_path, suffixes):
  return [pref(repo_root_relative_path, s) for s in suffixes]

def format_api_name(api, num):
  return api
  #return 'run api {}: {}'.format(num, api.replace("-api",""))

pp = {
  'grpc': '53',
  'web': '58',
  'debug': '60',
}

def create_api_resource(api, num, ports, depends_on):
  pf = []
  for typ in ports:
    forward = pp[typ] + num + ':' + str(ports[typ])
    pf += [forward]

  print("{} \t\t{}\n\tports: {}\n host:\t {}\n--------------".format(num, api, ports, pf))

  k8s_resource(
    api,
    new_name=format_api_name(api, num),
    port_forwards=pf,
    resource_deps=depends_on,
  )

def port_forward_resource(svc, num, ports):
  pf = ''
  for typ in ports:
    if typ == 'web':
      forward = pp[typ] + num + ':' + str(ports[typ])
      pf = forward
  return pf

