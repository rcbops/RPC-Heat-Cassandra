debconf-utils:
  pkg.installed:
    - require_in:
      - debconf: debconf-oracle-select

python-software-properties:
  pkg.installed:
    - require_in:
      - pkgrepo: webupd8team/java

webupd8team/java:
  pkgrepo.managed:
    - ppa: webupd8team/java
    - require_in:
      - pkg: oracle-java8-installer

debconf-oracle-select:
  debconf.set:
    - name: oracle-java8-installer
    - data:
        shared/accepted-oracle-license-v1-1:
          type: boolean
          value: true
    - require_in:
      - pkg: oracle-java8-installer

oracle-java8-installer:
  pkg.installed
