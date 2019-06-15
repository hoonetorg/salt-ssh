# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_client_install__pkg:
  pkg.installed:
    - pkgs: {{ ssh.client.pkgs | tojson }}
