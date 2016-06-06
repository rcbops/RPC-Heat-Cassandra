{% set p  = salt['pillar.get']('cassandra', {}) %}
{% set pc = p.get('config', {}) %}

{% set version        = p.get('version', '3.0.6') %}
{% set series         = p.get('series', '30x') %}
{% set package_name   = p.get('package_name', 'cassandra') %}
{% set conf_path      = p.get('conf_path', '/etc/cassandra/cassandra.yaml') %}

{% set private_interface      = salt['pillar.get']('interfaces:private', 'eth0') %}
{% set public_interface       = salt['pillar.get']('interfaces:public', 'eth0') %}

{% set default_config = {
  'cluster_name': 'Test Cluster',
  'data_file_directories': ['/var/lib/cassandra/data'],
  'commitlog_directory': '/var/lib/cassandra/commitlog',
  'saved_caches_directory': '/var/lib/cassandra/saved_caches',
  'listen_address': salt['network.ipaddrs'](private_interface)|first,
  'rpc_address': salt['network.ipaddrs'](public_interface)|first,
  'endpoint_snitch': 'SimpleSnitch'
  }%}

{%- set config = default_config %}

{%- do config.update(pc) %}

{% set cassandra_ips = salt['mine.get']('roles:cassandra', 'internal_ips', 'grain') %}
{% set cassandra_hosts = salt['mine.get']('roles:cassandra', 'host', 'grain') %}
{% set cassandra_hosts_dict = {} %}
{% for id, host in cassandra_hosts.iteritems() %}
    {% do cassandra_hosts_dict.update({host: (cassandra_ips[id])|first}) %}
{% endfor %}
{% set cassandra_ids = cassandra_hosts.keys() %}
{% do cassandra_ids.sort() %}
{% set seed_ips = [] %}
{% for seed_id in cassandra_ids[:2] %}
    {% do seed_ips.append(cassandra_ips[seed_id]|first) %}
{% endfor %}
{% do config.update({'seeds': seed_ips}) %}

{%- set cassandra = {
  'version': version,
  'series': series,
  'package_name': package_name,
  'conf_path': conf_path,
  'config': config,
  'cassandra_hosts': cassandra_hosts_dict,
  'connected_to_cluster': salt['grains.get']('connected_to_cluster', False)
} %}
