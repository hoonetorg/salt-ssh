# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_server__pkg:
  pkg.installed:
    - pkgs: {{ssh.pkgs.server}}
{% set slsrequires = ssh.server.slsrequires|default(False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
