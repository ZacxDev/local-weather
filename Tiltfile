# -*- mode: Python -*-

update_settings(max_parallel_updates=3)

load('tilt/helper.star', 'create_api_resource', 'format_api_name', 'port_forward_resource')
load('tilt/resource/k8s_misc.star', 'load_config_maps', 'load_namespace')
load('tilt/resource/services.star', 'get_services_to_run', 'run_services')
load('tilt/resource/external_services.star', 'run_external_services', 'run_container_registry', 'get_external_services_to_run')

print("context is: {}\n".format(k8s_context()))

allow_k8s_contexts('lowden-lindenshore')

# disable share button.
disable_snapshots()

cfgV2ServicesToRun='to_run'
config.define_string_list(cfgV2ServicesToRun)
cfgExternalServicesToRun='to_run_external'
config.define_string_list(cfgExternalServicesToRun)
cfg=config.parse()

load_namespace()
load_config_maps()

external_services=get_external_services_to_run(cfg[cfgExternalServicesToRun])
run_external_services(external_services)

go_service_collections = get_services_to_run(cfg[cfgV2ServicesToRun])

go_collection_services=[]
for c in go_service_collections:
  go_collection_services=go_collection_services+c['services']
  run_services(c['services'], 'go/service/{}'.format(c['name']))

service_registry = [
  ['weather-sensor',             '001', {'grpc': 443}, []],
  ['weather-backend',             '002', {'grpc': 443}, []],
  ['weather-frontend',             '003', {'web': 443}, []],
]

all_services = go_collection_services + external_services
services_to_rename=[]
for svc in all_services:
  for i in range(len(service_registry)):
    if service_registry[i][0] == svc:
      services_to_rename.append(service_registry[i])

for svc, num, ports, depends_on in services_to_rename:
  if not '_EXTERNAL' in depends_on:
    create_api_resource(svc, num, ports, depends_on)

# Run frontend
local_resource(
  'run: mimobl.com',
  serve_cmd='cd ui/mimobl.com && { npm run dev & npm run build; }',
  deps = ['ui/mimobl.com/.env', 'ui/mimobl.com/package.json', 'ui/mimobl.com/webpack.config.babel.js'],
  readiness_probe=probe(
    period_secs=15,
    http_get=http_get_action(port=9000, path="/")
  ),
  links=['http://localhost:9000'],
)
