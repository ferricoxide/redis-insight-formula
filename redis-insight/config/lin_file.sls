# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis_insight with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Ensure parent config-directory exists:
  file.directory:
    - group: {{ redis_insight.config.get('system_group', 'root') }}
    - makedirs: True
    - mode: 755
    - name: {{ salt['file.dirname'](redis_insight.config.global_cfg) }}
    - user: root

Manage global config-file:
  file.managed:
    - context:
        redis_insight: {{ redis_insight | json }}
    - name: {{ redis_insight.config.global_cfg }}
    - group: {{ redis_insight.config.get('system_group', 'root') }}
    - mode: 644
    - require:
      - file: 'Ensure parent config-directory exists'
    - source: {{ files_switch(['config.json.jinja'],
                              lookup='redis-insight-config-file-managed'
                 )
              }}
    - template: jinja
    - user: root
