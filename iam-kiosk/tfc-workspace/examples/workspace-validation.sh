#!/bin/bash
pip install --user yamllint >/dev/null
key=$(cat -|sed 's/.*:"\([^ ]*\)".*/\1/')
exitcode=0
if [[ $(yamllint -s $key) -eq "0" ]]; then
  echo "{\"exitcode\":\"$?\", \"message\":\"valid $key\"}"
else 
  echo "{\"exitcode\":\"$?\", \"message\":\"invalid $key\"}"
  exitcode=1
fi
exit $exitcode