#!/usr/bin/env python

import yaml
import sys
with open('.ls-ci.yaml', 'r') as stream:
	config = yaml.safe_load(stream)
	application = config['application']
	draftCharts = config['draftCharts']
	APP_NAME = application['name']
	ORG = application['org']
	GROUP_NAME = application['groupName']
	REPO = application['repo']
	LANG = application['lang']
	CHARTS_REPO = draftCharts['repository']
	TAG = draftCharts['tag']
	VALUES_FILE = draftCharts['valuesFile']
	# print("#!/bin/bash")
	print("export APP_NAME="+APP_NAME)
	print("export ORG="+ORG)
	print("export GROUP_NAME="+GROUP_NAME)
	print("export REPO="+REPO)
	print("export LANG="+LANG)
	print("export CHARTS_REPO="+CHARTS_REPO)
	print("export TAG="+TAG)
	print("export VALUES_FILE="+VALUES_FILE)