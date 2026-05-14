# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis_insight with context %}

include:
  - {{ sls_service_clean }}

redis-insight-config-clean-file-absent:
  file.absent:
    - name: {{ redis_insight.config }}
    - require:
      - sls: {{ sls_service_clean }}
