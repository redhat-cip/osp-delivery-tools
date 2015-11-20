#!/bin/bash
#
# Copyright (C) 2015 Red Hat, Inc.
#
# Author: Hugo Rosnet <hrosnet@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

OUTPUT_TO_FILE=false
STACK=overcloud
LEVEL=3
FILE="deploy-fail-$(date '+%Y%m%d-%H%M%S').txt"

# Matching for "server_id": "c18426be-fb53-48e7-9dc5-4d96b394ea69"
MATCH_DEPLOY='[[:alnum:]]\{8\}-\([[:alnum:]]\{4\}-\)\{3\}[[:alnum:]]\{12\}'

function _usage() {
	echo "This script allow to have all errors/server name/IP from resources that failed during a deployment."
	echo ""
	echo "Usage: ${0}"
	echo "  -f : Output to file 'deploy-fail-DATE' as well. (default: False)"
	echo "  -s : Name of the stack to analyze. (default: overcloud)"
	echo "  -l : Level of depth for the stack. (default: 3)"
	echo ""
	echo "Think about sourcing your FILErc, this script will NOT do it."
}

while getopts "fs:l:h" opt; do
	case ${opt} in
	  f)
		OUTPUT_TO_FILE=true
		;;
	  s)
		STACK=${OPTARG}
		;;
	  l)
		LEVEL=${OPTARG}
		;;
	  h)
		_usage
		exit 0
		;;
	  \?)
		_usage
		exit 1
		;;
	esac
done

if ${OUTPUT_TO_FILE}; then
	exec > >(tee ${FILE})
	exec 2>&1
fi

RESOURCES=$(heat resource-list -n ${LEVEL} ${STACK} | awk '/FAILED/{print $4}')

for rsc_id in ${RESOURCES}
do
	echo "Resource ${rsc_id}:"
	heat deployment-output-show ${rsc_id} --all
	HEAT_OUTPUT="$(heat deployment-show ${rsc_id})"
	if ! [ -z "${HEAT_OUTPUT}" ]; then
		SERVER_ID=$(echo ${HEAT_OUTPUT} | grep -oP "server_id.*?," | grep -o ${MATCH_DEPLOY})
		echo "Server $(nova list | awk "/${SERVER_ID}/{print \$4 \" => \" \$12}")"
	fi
	echo '-------------------------'
done

exit 0
