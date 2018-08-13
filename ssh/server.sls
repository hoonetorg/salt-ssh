# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_server__require:
  cmd.run:
    - name: true
    - unless: true
{% if ssh.get('server', {}).get('slsrequires', False ) %}
    - require:
{% for slsrequire in ssh.get('server', {}).get('slsrequires')|sort %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

include:
  - ssh.server_install
  - ssh.server_config
  - ssh.server_service

extend:
  ssh_server_install__pkg:
    pkg:
      - require:
        - cmd: ssh_server__require

  ssh_server_config__config_finished:
    cmd:
      - require:
        - cmd: ssh_server__require
        - pkg: ssh_server_install__pkg

  ssh_server_service__service:
    service:
{% if ssh.get('server', {}).get('config', False)  %}
      - watch:
        - augeas: ssh_server_config__config
{% endif %}
      - require:
        - cmd: ssh_server__require
        - pkg: ssh_server_install__pkg
        - cmd: ssh_server_config__config_finished
