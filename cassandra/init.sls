{%- from 'cassandra/cassandra/settings.sls' import cassandra with context %}

include:
  - cassandra.java
  - cassandra.cassandra.hosts

cassandra_package:
  pkgrepo.managed:
    - humanname: Cassandra Debian Repo
    - name: deb http://debian.datastax.com/community stable main
    - file: /etc/apt/sources.list.d/cassandra.sources.list
    - key_url: http://debian.datastax.com/debian/repo_key
  pkg.installed:
    - name: {{ cassandra.package_name }}
    - version: {{ cassandra.version }}

cassandra_configuration:
  file.managed:
    - name: {{ cassandra.conf_path }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://cassandra/cassandra/conf/cassandra_{{ cassandra.series }}.yaml
    - template: jinja
    - require:
      - pkg: cassandra_package
    - watch_in:
      - service: cassandra_service

{% for d in cassandra.config.data_file_directories %}
data_file_directories_{{ d }}:
  file.directory:
    - name: {{ d }}
    - user: cassandra
    - group: cassandra
    - mode: 755
    - makedirs: True
{% endfor %}

commitlog_directory:
  file.directory:
    - name: {{ cassandra.config.commitlog_directory }}
    - user: cassandra
    - group: cassandra
    - mode: 755
    - makedirs: True

saved_caches_directory:
  file.directory:
    - name: {{ cassandra.config.saved_caches_directory }}
    - user: cassandra
    - group: cassandra
    - mode: 755
    - makedirs: True

cassandra_service:
  service.running:
    - name: cassandra
    - enable: True
    - init_delay: 30
    - require:
      - file: commitlog_directory
      - file: saved_caches_directory
{% for d in cassandra.config.data_file_directories %}
      - file: data_file_directories_{{ d }}
{% endfor %}
