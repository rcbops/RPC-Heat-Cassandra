{%- from 'cassandra/cassandra/settings.sls' import cassandra with context -%}
{% for host, ip in cassandra.cassandra_hosts.items() %}
host-{{ host }}:
  host.present:
    - ip: {{ ip }}
    - names:
      - {{ host }}
{% endfor %}
