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
    echo " translating."
    yq -Y '.Name = (.Name | split("-") | .[3] + "-" + .[4])' $i >/tmp/$$.yaml
    sed 's/-$//' /tmp/$$.yaml > $i
  fi
done
