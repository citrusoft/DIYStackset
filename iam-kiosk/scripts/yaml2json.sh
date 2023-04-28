#!/bin/bash
#
# Filename    : simplify-name.sh
# Date        : Mar 31, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : Remove the prefixes from the original user-names.

# set -x
# pip install yq
for i in /Users/TAHV/tmp/resources/*/service-accounts/*.yaml
do
  echo -n "$i "
  grep -qe '^Name: ' $i
  if [ $? = '0' ]
  then
    echo " translating to /tmp/$$.json"
    awk 'BEGIN { print "Version: \"2012-10-17\"" } { print $0 }' $i | yq -o=json 'del(.Name, .Tags, .ManagedPolicyArns)' >/tmp/$$.json
    grep -qe '^Statement:' $i
    if [ $? = '0' ]
    then
      aws accessanalyzer validate-policy \
        --policy-type IDENTITY_POLICY \
        --policy-document file:///tmp/$$.json
      filename="${i%yaml}json"
      mv /tmp/$$.json ${filename}
      echo ${filename}
    fi
  fi
done
