# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_client__pkg:
  pkg.installed:
    - pkgs: {{ssh.pkgs.client}}
{% set slsrequires = ssh.client.slsrequires|default(False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
