ssh_hosts__pkg_sshd:
  pkg.installed:
    - name: openssh-server
{% set slsrequires =salt['pillar.get']('ssh:hosts:slsrequires', False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}

ssh_hosts__pkg_ssh:
  pkg.installed:
    - name: openssh-clients
    - require:
      - pkg: ssh_hosts__pkg_sshd

ssh_hosts__file_/etc/ssh/ssh_host_key:
  file.absent:
    - name: /etc/ssh/ssh_host_key
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_key.pub
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_dsa_key:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_dsa_key.pub:
  file.absent:
    - name: /etc/ssh/ssh_host_dsa_key.pub
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_ecdsa_key:
  file.managed:
    - name: /etc/ssh/ssh_host_ecdsa_key
    - source: salt://files/keys/hosts/{{grains['id']}}/ssh_host_ecdsa_key
    - show_diff: False
    - user: root
    - group: ssh_keys
    - mode: 600
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_ecdsa_key.pub:
  file.managed:
    - name: /etc/ssh/ssh_host_ecdsa_key.pub
    - contents_pillar: 'nodedata:{{grains['id']}}:sshdata:ssh_host_ecdsa_key_pub'
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_ed25519_key:
  file.managed:
    - name: /etc/ssh/ssh_host_ed25519_key
    - source: salt://files/keys/hosts/{{grains['id']}}/ssh_host_ed25519_key
    - show_diff: False
    - user: root
    - group: ssh_keys
    - mode: 600
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_ed25519_key.pub:
  file.managed:
    - name: /etc/ssh/ssh_host_ed25519_key.pub
    - contents_pillar: 'nodedata:{{grains['id']}}:sshdata:ssh_host_ed25519_key_pub'
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_rsa_key:
  file.managed:
    - name: /etc/ssh/ssh_host_rsa_key
    - source: salt://files/keys/hosts/{{grains['id']}}/ssh_host_rsa_key
    - show_diff: False
    - user: root
    - group: ssh_keys
    - mode: 600
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_host_rsa_key.pub:
  file.managed:
    - name: /etc/ssh/ssh_host_rsa_key.pub
    - contents_pillar: 'nodedata:{{grains['id']}}:sshdata:ssh_host_rsa_key_pub'
    - user: root
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh_hosts__pkg_ssh

ssh_hosts__file_/etc/ssh/ssh_known_hosts:
  file.managed:
    - name: /etc/ssh/ssh_known_hosts
    - source: salt://ssh/ssh_known_hosts.jinja
    - template: jinja 
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh_hosts__pkg_ssh

