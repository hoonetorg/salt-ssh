# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

ssh_server_install__pkg:
  pkg.installed:
    - pkgs: {{ ssh.server.pkgs | tojson}}
