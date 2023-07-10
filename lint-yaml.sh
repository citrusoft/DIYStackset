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

pip  --trusted-host pypi.org --trusted-host files.pythonhosted.org install yamllint # >/dev/null

for file in `find $1 -type f -print`
do
  if [[ $file =~ $REGEX ]]; then
    echo $file
    yamllint -s -d "{extends: default, rules: {new-lines: disable, line-length: {max: 180}}}" $file
    evaluate_returned_status $?
  fi
done

exit $EXIT_CODE
