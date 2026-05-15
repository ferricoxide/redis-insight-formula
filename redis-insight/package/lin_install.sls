# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis_insight with context %}

{%- set target_arch = grains.get('osarch', 'x86_64') %}
{%- set redis_rpm = '/tmp/Redis-Insight-linux-' ~ target_arch ~ '.rpm' %}
{%- set redis_install_loc = '/usr/local/bin' %}

{#- Determine the download URI #}
{%- set download_uri = redis_insight.pkg.download_uri %}
{%- set api_response = {} %}

{%- if not download_uri %}
  {%- set api_url =
      'https://api.github.com/repos/redis/RedisInsight/releases/latest' %}
  {%- set api_response = salt['http.query'](
        api_url, decode=True, decode_type='json'
      ) %}

  {%- if 'dict' in api_response and 'tag_name' in api_response['dict'] %}
    {%- set latest_tag = api_response['dict']['tag_name'] %}
    {%- set version_num = latest_tag | replace('v', '') %}
    {%- set download_uri =
      'https://github.com/redis/RedisInsight/releases/download/' ~ latest_tag ~
      '/Redis-Insight-linux-' ~ target_arch ~ '.rpm' %}
  {%- endif %}
{%- endif %}

{%- if not download_uri %}
Halt Installation Due to Missing URL:
  test.fail_without_changes:
    - name: 'Failed to construct download_uri. Please provide the URL manually in Pillar.'
    - failhard: True
{%- elif redis_insight.pkg.download_uri %}
Download REDIS Insight RPM:
  file.managed:
    - name: '{{ redis_rpm }}'
    - skip_verify: True
    - source: '{{ redis_insight.pkg.download_uri }}'
    - onchanges_in:
      - pkg: 'Install REDIS Insight Dependencies'

{%- else %}
Download REDIS Insight RPM:
  cmd.run:
    - name: 'curl -sSLf -o {{ redis_rpm }} {{ download_uri }}'
    - unless: 'test -s {{ redis_rpm }}'
    - onchanges_in:
      - pkg: 'Install REDIS Insight Dependencies'
{%- endif %}

Install REDIS Insight Dependencies:
  pkg.installed:
    - pkgs:
      - alsa-lib
      - at-spi2-atk
      - dejavu-sans-fonts
      - libX11
      - libXcomposite
      - libXdamage
      - libXext
      - libXfixes
      - libXrandr
      - libdrm
      - mesa-libgbm
      - nss
    - require:
      {%- if redis_insight.pkg.download_uri %}
      - file: 'Download REDIS Insight RPM'
      {%- else %}
      - cmd: 'Download REDIS Insight RPM'
      {%- endif %}

Extract REDIS Insight Files:
  cmd.run:
    - cwd: /
    - name: 'rpm2cpio {{ redis_rpm }} | cpio -idmv'
    - require:
      - pkg: 'Install REDIS Insight Dependencies'
    - unless: 'rpm -q {{ redis_insight.pkg.name }}'

Install REDIS Insight RPM (DB only):
  pkg.installed:
    - extra_install_args:
      - --nogpgcheck
      - --setopt=tsflags=justdb,nodigest
    - require:
      - cmd: 'Extract REDIS Insight Files'
    - sources:
      - {{ redis_insight.pkg.name }}: {{ redis_rpm }}

Remove staged REDIS Insight RPM:
  file.absent:
    - name: '{{ redis_rpm }}'
    - require:
      - pkg: 'Install REDIS Insight RPM (DB only)'
