#
#  Filename    : modules/workspaces/scripts/add_teams_access.py
#  Date        : 18 July 2022
#  Author      : Jacob Taunton (j2tw@pge.com)
#  Description : Trigger teams access workspace to run after workspace is created
#

import os
import argparse
import requests

########################################################################################
#Default values can be changed to your specific key, or you can pass them in CLI.
parser = argparse.ArgumentParser()
# parser.add_argument('-t', '--token', help="tfe token", default=None)
# configured with test
parser.add_argument('-w', '--workspace', help="workspace id", default="ws-FNarHz5SkxxUGGo7")
args = parser.parse_args()
########################################################################################

def trigger_workspace_run(api_headers, workspace_id):
    """Makes API Call to TFC to trigger workspace run to attach policy set"""
    url = 'https://app.terraform.io/api/v2/runs'
    post_data = '{"data": {"attributes": {"message": "running after workspace create IaC"}, \
    "type":"runs", "relationships": {"workspace": {"data": {"type": "workspaces", "id": \
        "'+ workspace_id +'" }}}}}'
    response = requests.post(url, headers=api_headers, data=post_data)
    print(response)
    print(response.text)

def main():
    """Gets the args needed to add trigger run in workspace"""
    # token = args.token
    token = os.environ.get('WORKSPACE_ADMIN')
    api_headers= {'content-type': 'application/vnd.api+json', "Authorization": "Bearer " + token}
    workspace_id = args.workspace # comes from argparse -w
    trigger_workspace_run(api_headers, workspace_id)

#Code starts here
if __name__ == "__main__":
    main()
