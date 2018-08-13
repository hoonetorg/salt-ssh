# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_server_service__service:
  service.{{ ssh.server.service.state }}:
    - name: {{ ssh.server.service.name }}
{% if ssh.server.service.state in [ 'running', 'dead' ] %}
    - enable: {{ ssh.server.service.enable }}
{% endif %}

