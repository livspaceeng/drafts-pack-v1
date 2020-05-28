#!/usr/bin/env python

import yaml
import sys
with open('.ls-ci.yaml', 'r') as stream:
	config = yaml.safe_load(stream)
	application = config['application']
	helmCharts = config['helmCharts']
	APP_NAME = application['name']
	ORG = application['org']
	GROUP_NAME = application['groupName']
	REPO = application['repo']
	LANG = application['lang']
	CHARTS_URI = helmCharts['uri']
	if 'tag' in helmCharts:
		TAG = helmCharts['tag']
	else:
		TAG = 'latest'
	if 'valuesFile' in helmCharts:
		VALUES_FILE = helmCharts['valuesFile']
	else:
		VALUES_FILE = 'valuesFile'
	print("#!/bin/sh")
	print("export APP_NAME="+APP_NAME)
	print("export ORG="+ORG)
	print("export GROUP_NAME="+GROUP_NAME)
	print("export REPO="+REPO)
	print("export LANG="+LANG)
	print("export CHARTS_URI="+CHARTS_URI)
	print("export TAG="+TAG)
	print("export VALUES_FILE="+VALUES_FILE)