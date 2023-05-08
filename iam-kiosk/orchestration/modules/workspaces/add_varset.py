#
#  Filename    : modules/workspaces/add_varset.py
#  Date        : 11 Apr 2022
#  Author      : Jacob Taunton (j2tw@pge.com)
#  Description : Attach existing varsets to workspaces
#

import argparse
import requests

########################################################################################
#Default values can be changed to your specific key, or you can pass them in CLI.
parser = argparse.ArgumentParser()
parser.add_argument('-t', '--token', help="tfe token", default=None)
parser.add_argument('-w', '--workspace', help="workspace id", default=None)
parser.add_argument('-v', '--varset', help="varset name", default=None)
args = parser.parse_args()
########################################################################################

def add_varset_to_workspace(api_headers, varset_id, workspace_id):
  """Makes API Call to TFC to add varset ID to workspace ID"""
  url = 'https://app.terraform.io/api/v2/varsets/' + varset_id + '/relationships/workspaces'
  post_data = '{ "data": [ { "type": "workspaces", "id": "'+ workspace_id +'" } ] }'
  response = requests.post(url, headers=api_headers,  data=post_data)
  print(response)
  print(response.text)

def main():
  """Gets the args needed to add the varset to the workspace"""
  token = args.token
  api_headers= {'content-type': 'application/vnd.api+json', "Authorization": "Bearer " + token}
  varset_id = args.varset # comes from argparse -v
  workspace_id = args.workspace # comes from argparse -w
  add_varset_to_workspace(api_headers, varset_id, workspace_id)

#Code starts here
if __name__ == "__main__":
  main()
