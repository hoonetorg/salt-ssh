# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_hosts__file_/etc/ssh/ssh_host_key:
  file.absent:
    - name: /etc/ssh/ssh_host_key
{% set slsrequires =salt['pillar.get']('ssh:hosts:slsrequires', False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

ssh_hosts__file_/etc/ssh/ssh_host_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_key.pub
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key


ssh_hosts__file_/etc/ssh/ssh_host_dsa_key:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key

ssh_hosts__file_/etc/ssh/ssh_host_dsa_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key.pub
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key

{% for host_cipher in ssh.host_ciphers %}
ssh_hosts__file_/etc/ssh/ssh_host_{{host_cipher}}_key:
  file.managed:
    - name: /etc/ssh/ssh_host_{{host_cipher}}_key
    - contents: {{ssh['hosts']['ssh_host_keys'][grains['id']]['ssh_host_' + host_cipher +'_key_priv']|yaml_encode}}
    - show_diff: False
    - user: root
    - group: ssh_keys
    - mode: 600
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key

ssh_hosts__file_/etc/ssh/ssh_host_{{host_cipher}}_key.pub:
  file.managed:
    - name: /etc/ssh/ssh_host_{{host_cipher}}_key.pub
    - contents: {{ssh['hosts']['ssh_host_keys'][grains['id']]['ssh_host_' + host_cipher +'_key_pub']|yaml_encode}}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key
{% endfor %}

ssh_hosts__file_/etc/ssh/ssh_known_hosts:
  file.managed:
    - name: /etc/ssh/ssh_known_hosts
    - source: salt://ssh/templates/ssh_known_hosts.jinja
    - template: jinja
    - context: 
        ssh: {{ssh|yaml}}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: ssh_hosts__file_/etc/ssh/ssh_host_key
