cassandra:
  version: 3.0.6
  series: 30x
  package_name: cassandra
  conf_path: /etc/cassandra/cassandra.yaml
  config:
    cluster_name: 'cassandra'
    data_file_directories:
      - /var/lib/cassandra/data
    commitlog_directory: /var/lib/cassandra/commitlog
    saved_caches_directory: /var/lib/cassandra/saved_caches
    endpoint_snitch: SimpleSnitch

interfaces:
  public: eth0
  private: eth2

mine_functions:
  internal_ips:
    mine_function: network.ipaddrs
    interface: eth2
  external_ips:
    mine_function: network.ipaddrs
    interface: eth0
  id:
    - mine_function: grains.get
    - id
  host:
    - mine_function: grains.get
    - host

user-ports:
  ssh:
    chain: INPUT
    proto: tcp
    dport: 22
  salt-master:
    chain: INPUT
    proto: tcp
    dport: 4505
  salt-minion:
    chain: INPUT
    proto: tcp
    dport: 4506
  storage_port:
    chain: INPUT
    proto: tcp
    dport: 7000
  storage_port_ssl:
    chain: INPUT
    proto: tcp
    dport: 7001
  client_port:
    chain: INPUT
    proto: tcp
    dport: 9042
  thrift_port:
    chain: INPUT
    proto: tcp
    dport: 9160
