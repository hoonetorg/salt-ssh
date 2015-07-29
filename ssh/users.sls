ssh_users__file_/root/.ssh:
  file.directory:
    - name: /root/.ssh
    - user: root
    - group: root
    - mode: 700
    - makedirs: True
{% set slsrequires =salt['pillar.get']('ssh:users:slsrequires', False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}


ssh_users__fileexist_/root/.ssh/authorized_keys:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - user: root
    - group: root
    - mode: 444
    - require:
      - file: ssh_users__file_/root/.ssh
ssh_users__file_/root/.ssh/authorized_keys:
  file.append:
    - name: /root/.ssh/authorized_keys
    - text:
{% for user , userdata in salt['pillar.get']('userdata', {}).items() %}{% if userdata.sshdata.ssh_user_key_pub is defined and userdata.sshdata.ssh_user_key_pub %}
      - "{{userdata.sshdata.ssh_user_key_pub}}"
{% endif %}{% endfor %}
    - require:
      - file: ssh_users__file_/root/.ssh

ssh_users__file_/root/.ssh/id_ecdsa:
  file.managed:
    - name: /root/.ssh/id_ecdsa
    - source: salt://files/keys/users/root/id_ecdsa
    - show_diff: False
    - template: jinja 
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: ssh_users__file_/root/.ssh

ssh_users__file_/root/.ssh/id_ecdsa.pub:
  file.managed:
    - name: /root/.ssh/id_ecdsa.pub
    - contents_pillar: 'userdata:root:sshdata:ssh_user_key_pub'
    - template: jinja 
    - user: root
    - group: root
    - mode: 444
    - require:
      - file: ssh_users__file_/root/.ssh
