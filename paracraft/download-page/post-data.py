#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2017 zdw <zdw@zdw-mint>
#
# Distributed under terms of the MIT license.

"""
Generate post data for gitlab api

usage:

   ./post-data.py \
     --version 0.7.838 \
     --baiduyun_link 'http://pan.baidu.com/s/1dFuYuJJ' \
     --launcher_link 'http://www.nplproject.com/download/paracraft/latest/ParacraftLauncher.exe' \
     --full_link 'http://www.nplproject.com/zh/download/paracraft/latest/paracraft_full.exe' \
     --andriod_link 'http://www.pgyer.com/bUyL' \
     --ios_link 'http://www.pgyer.com/para'

"""

from string import Template
from json import dumps
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--version", type=str, help="current version")
parser.add_argument("--baiduyun_link", type=str, help="baiduyun address")
parser.add_argument("--launcher_link", type=str, help="launcher address")
parser.add_argument("--full_link", type=str, help="full pacakge address")
parser.add_argument("--andriod_link", type=str, help="andriod address")
parser.add_argument("--ios_link", type=str, help="ios address")

args = parser.parse_args()
fillin = args.__dict__

content = open('page.template').read()
tem = Template(content)
post_content = tem.safe_substitute(fillin)

post_data = dict(
    branch='master',
    commit_message='update from gitlab api',
    actions=[
        dict(
            action='update',
            file_path='dreamanddead/downloads/index.md',
            content=post_content
        )
    ]
)

print(dumps(post_data))
