# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "ssh/map.jinja" import ssh with context %}

/tmp/ssh.yaml:
  file.managed:
    - contents: |
        {{ssh|yaml(False)|indent(8)}}
