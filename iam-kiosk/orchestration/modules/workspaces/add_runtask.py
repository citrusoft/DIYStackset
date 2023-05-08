#
#  Filename    : modules/workspaces/add_runtask.py
#  Date        : 22 Apr 2022
#  Author      : Jacob Taunton (j2tw@pge.com)
#  Description : Attach existing runtask to workspaces
#

import argparse
import requests

########################################################################################
#Default values can be changed to your specific key, or you can pass them in CLI.
parser = argparse.ArgumentParser()
parser.add_argument('-t', '--token', help="tfe token", default=None)
parser.add_argument('-w', '--workspace', help="workspace id", default=None)
parser.add_argument('-r', '--runtask', help="runtask id", default=None)
args = parser.parse_args()
########################################################################################

def add_runtask_to_workspace(api_headers, workspace_id, runtask_id):
  """Makes API Call to TFC to add runtask ID to workspace ID"""
  url = 'https://app.terraform.io/api/v2/workspaces/' + workspace_id + '/tasks'
  post_data = '{"data": { "type": "workspace-tasks",  "attributes": { "enforcement-level": "advisory" }, \
    "relationships": { "task": { "data": { "id": "'+ runtask_id +'", "type": "tasks" }}}}}'

  response = requests.post(url, headers=api_headers,  data=post_data)
  print(response)
  print(response.text)

def main():
  """Gets the args needed to add the runtask to the workspace"""
  token = args.token
  api_headers= {'content-type': 'application/vnd.api+json', "Authorization": "Bearer " + token}
  runtask_id = args.runtask # comes from argparse -r
  workspace_id = args.workspace # comes from argparse -w
  add_runtask_to_workspace(api_headers, workspace_id, runtask_id)

#Code starts here
if __name__ == "__main__":
  main()
