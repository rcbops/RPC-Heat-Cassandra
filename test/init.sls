/root/test.sh:
  file.managed:
    - source: salt://cassandra/test/files/test.sh.jinja2
    - template: jinja

bash /root/test.sh:
  cmd.run:
    - require:
      - file: /root/test.sh
