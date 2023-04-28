#!/bin/bash
#
# Filename    : grammar2iam.sh
# Date        : Mar 23, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : translate the YAML for service-accounts & federated-roles
#               into AWS IAM Policy grammar.
# set -x
for i in ./resources/*/*/*.yaml
do
  echo -n "$i "
  grep -qe '- Name: \|^Policies:' $i
  if [ $? = '0' ]
  then
    echo " translating."
    sed 's/- Name: /- Sid: /' $i | sed 's/^Policies:/Statement:/' >/tmp/$$.yaml
    mv /tmp/$$.yaml $i
  fi
done
