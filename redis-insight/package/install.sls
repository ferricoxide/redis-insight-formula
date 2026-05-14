# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis_insight with context %}

redis-insight-package-install-pkg-installed:
  pkg.installed:
    - name: {{ redis_insight.pkg.name }}
