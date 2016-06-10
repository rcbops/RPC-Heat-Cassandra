# Warning. This is a destructive state.
# This state should only be used to start a cassandra cluster that has NO data.
# Debian cassandra packages start the cassandra service with the wrong cluster name.
# We must stop cassandra, flush default data, then restart cassandra.
# This should be run after state.highstate
stop_cassandra:
  service.dead:
    - name: cassandra

clear_default_data:
  cmd.run:
    - name: rm -rf /var/lib/cassandra/data/system/*
    - require:
      - service: stop_cassandra

/var/log/cassandra/system.log:
  file.absent:
    - require:
      - service: stop_cassandra

start_cassandra:
  service.running:
    - name: cassandra
    - require:
      - cmd: clear_default_data
      - file: /var/log/cassandra/system.log

salt://cassandra/cassandra/scripts/wait_for_start.sh:
  cmd.script:
    - require:
      - service: start_cassandra
