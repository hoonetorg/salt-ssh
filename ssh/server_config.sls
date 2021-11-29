# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

{% if ssh.get('server', {}).get('config', False)  %}
ssh_server_config__config:
  augeas.change:
    - name: {{ ssh.server.conffile }}
#    - lens: sshd_config
    - context: /files{{ ssh.server.conffile }}
    - changes:
  {% for server_config, server_config_data in ssh.get('server', {}).get('config', {}).items()|sort %}
      - rm {{server_config}}
      - set {{server_config}} {{server_config_data}}
  {% endfor %}
{% endif %}


ssh_server_config__config_finished:
  cmd.run:
    - name: "true"
    - unless: "true"


