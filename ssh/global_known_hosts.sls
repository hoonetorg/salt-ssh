# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_global_known_hosts__require:
  cmd.run:
    - name: true
    - unless: true
{% if ssh.get('global_known_hosts', {}).get('slsrequires', False ) %}
    - require:
{% for slsrequire in ssh.get('global_known_hosts', {}).get('slsrequires')|sort %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

{% if ssh.get('global_known_hosts', {}).get('ssh_host_keys', False ) %}
ssh_global_known_hosts__conffile:
  file.managed:
    - name: {{ssh.global_known_hosts.conffile}}
    - source: salt://ssh/templates/ssh_known_hosts.jinja
    - template: jinja
    - context: 
        ssh: {{ssh|yaml}}
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: ssh_global_known_hosts__require
{% endif %}
