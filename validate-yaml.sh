#!/bin/bash
#
# Filename    : validate-yaml.sh
# Date        : Mar 23, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : Validate the given yaml documents.
#               Accepts file-paths separated with whitespace.

if [ "$#" -lt 1 ]; then
  echo "Usage: validate-yaml.sh directory"
  exit -1
fi
function evaluate_returned_status() {
  if [ "$1" != "0" ]; then
    EXIT_CODE=$1
  fi
}

EXIT_CODE=0
REGEX='.*/resources/[0-9]{12}/(federated\-roles|service\-accounts)/.*\.yaml$'

pip  --trusted-host pypi.org --trusted-host files.pythonhosted.org install yamllint jq yq # >/dev/null

for file in `find $1 -type f -print`
do
  if [[ $file =~ $REGEX ]]; then
    echo "YYYYYYYYYYYYYYYYYYyamllint $file"
    yamllint -s -d "{extends: default, rules: {new-lines: disable, line-length: {max: 180}}}" $file
    evaluate_returned_status $?
    json_file="`echo "$file" | awk -F '.' '{print $1}'`"
    json_file="${json_file}.json"
    echo "VVVVVVVVVVVVVVVVVVvalidate-policy ${json_file}"
    echo -n '{ "Version": "2012-10-17", "Statement": ' >$json_file
    yq  .Statement $file >>$json_file
    echo ' }' >>$json_file
    jq . ${json_file} >policy_file.json
    mv policy_file.json ${json_file}
    cat -n ${json_file}
    aws accessanalyzer validate-policy --policy-type IDENTITY_POLICY --policy-document "file://${json_file}"
    evaluate_returned_status $?
    rm ${json_file}
  fi
done

exit $EXIT_CODE
