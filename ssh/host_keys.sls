# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_host_keys__require:
  cmd.run:
    - name: true
    - unless: true
{% if ssh.get('host_keys', {}).get('slsrequires', False ) %}
    - require:
{% for slsrequire in ssh.get('host_keys', {}).get('slsrequires')|sort %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

ssh_host_keys__file_/etc/ssh/ssh_host_key:
  file.absent:
    - name: /etc/ssh/ssh_host_key
    - require:
      - cmd: ssh_host_keys__require

ssh_host_keys__file_/etc/ssh/ssh_host_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_key.pub
    - require:
      - cmd: ssh_host_keys__require


ssh_host_keys__file_/etc/ssh/ssh_host_dsa_key:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key
    - require:
      - cmd: ssh_host_keys__require

ssh_host_keys__file_/etc/ssh/ssh_host_dsa_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key.pub
    - require:
      - cmd: ssh_host_keys__require

{% for host_cipher in ssh.host_ciphers %}
  {% if ssh.get('host_keys', {}).get('ssh_host_' + host_cipher +'_key_priv', False) %}
ssh_host_keys__file_/etc/ssh/ssh_host_{{host_cipher}}_key:
  file.managed:
    - name: /etc/ssh/ssh_host_{{host_cipher}}_key
    - contents: {{ssh.get('host_keys', {}).get('ssh_host_' + host_cipher +'_key_priv')|yaml_encode}}
    - show_diff: False
    - user: root
    - group: ssh_keys
    - mode: 600
    - require:
      - cmd: ssh_host_keys__require
  {% endif %}

  {% if ssh.get('host_keys', {}).get('ssh_host_' + host_cipher +'_key_pub', False) %}
ssh_host_keys__file_/etc/ssh/ssh_host_{{host_cipher}}_key.pub:
  file.managed:
    - name: /etc/ssh/ssh_host_{{host_cipher}}_key.pub
    - contents: {{ssh.get('host_keys', {}).get('ssh_host_' + host_cipher +'_key_pub')|yaml_encode}}
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: ssh_host_keys__require
  {% endif %}
{% endfor %}
