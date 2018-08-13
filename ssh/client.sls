# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_client__require:
  cmd.run:
    - name: true
    - unless: true
{% if ssh.get('client', {}).get('slsrequires', False ) %}
    - require:
{% for slsrequire in ssh.get('client', {}).get('slsrequires')|sort %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

include:
  - ssh.client_install
  - ssh.client_config

extend:
  ssh_client_install__pkg:
    pkg:
      - require:
        - cmd: ssh_client__require

  ssh_client_config__config_finished:
    cmd:
      - require:
        - cmd: ssh_client__require
        - pkg: ssh_client_install__pkg
