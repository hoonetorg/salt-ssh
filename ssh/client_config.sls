# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

{% if ssh.get('client', {}).get('config', False)  %}
ssh_client_config__config:
  augeas.change:
    - name: {{ ssh.client.conffile }}
#    - lens: sshd_config
    - context: /files{{ ssh.client.conffile }}
    - changes:
  {% for client_config, client_config_data in ssh.get('client', {}).get('config', {}).items()|sort %}
      - rm {{client_config}}
      - set {{client_config}} {{client_config_data}}
  {% endfor %}
{% endif %}


ssh_client_config__config_finished:
  cmd.run:
    - name: "true"
    - unless: "true"


