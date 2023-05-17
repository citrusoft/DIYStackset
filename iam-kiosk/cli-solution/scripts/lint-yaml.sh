#!/bin/bash
#
# Filename    : lint-yaml.sh
# Date        : Mar 23, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : Validate the given yaml documents.
#               Accepts file-paths separated with whitespace.

function evaluate_returned_status() {
  if [ "$1" != "0" ]; then
    EXIT_CODE=$1
  fi
}

EXIT_CODE=0
REGEX='.*/resources/[0-9]{12}/(federated\-roles|service\-accounts)/.*\.yaml$'

pip install yamllint >/dev/null

for file in `find ./cscoe-iam-kiosk/test/resources -type f -print`
do
  echo $1
  if [[ $1 =~ $REGEX ]]; then
    yamllint -s -d "{extends: default, rules: {new-lines: disable, line-length: {max: 180}}}" $1
    evaluate_returned_status $?
  fi
  shift
done

exit $EXIT_CODE
