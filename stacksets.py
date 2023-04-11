import argparse
import glob
import os
import subprocess
import re

import boto3

# RESOURCE_PATH = "/Users/TAHV/tmp/resources"
RESOURCE_PATH = "/Users/TAHV/git/aws-lz-iam/cscoe-iam-kiosk/test/"

def init():
  subprocess.run(f"terraform init", check=True, shell=True)

def get_paths_from_dir() -> list:

  # Extract all the list of items recursively
  files = glob.glob(RESOURCE_PATH + '**/service-accounts/*', recursive=True)
 
  # Filter only files
  files = [f for f in files if os.path.isfile(f)]

  for filename in files:
    print(filename)
  return files


def get_accounts_from_paths() -> list:

  paths = get_paths_from_dir()
          
  # for path in paths:
  #   print(re.findall("[0-9]{12}", path))
    # print(path.split("/"))
  return [
        re.findall("[0-9]{12}", path)[0]
        for path in paths
  ]

def get_accounts_from_orgs():
  organizations = boto3.client('organizations')
  paginator = organizations.get_paginator("list_accounts")

  return [
        account["Id"]
        for page in paginator.paginate()
        for account in page["Accounts"]
  ]

def workspace_exists(account):
  completed_process = subprocess.run(f"terraform workspace list | grep {account}", shell=True)
  return completed_process.returncode == 0

def create_workspace(account):
  subprocess.run(f"terraform workspace new {account}", check=True, shell=True)

def switch_to_workspace(account):
  subprocess.run(f"terraform workspace select {account}", check=True, shell=True)

def plan(account):
  subprocess.run(f"terraform plan -var target_account_id={account}", check=True, shell=True)

def apply(account):
  subprocess.run(f"terraform apply -var target_account_id={account} -auto-approve", check=True, shell=True)

def destroy(account):
  subprocess.run(f"terraform destroy -var target_account_id={account} -auto-approve", check=True, shell=True)

def run():
  init()
  for account in get_accounts_from_paths():
    # if account != "424304752381":
    #   continue
    if not workspace_exists(account):
      create_workspace(account)
    switch_to_workspace(account)
    if args.plan:
      plan(account)
    if args.apply:
      apply(account)
    if args.destroy:
      destroy(account)

parser = argparse.ArgumentParser(
                    prog='terrastacks',
                    description='stackset-esque functionality for your Terraform code.',
                    epilog='This will make deploying common infrastructure across AWS accts significantly simpler.')
group = parser.add_mutually_exclusive_group()
group.add_argument('-a', '--apply', action='store_true')
group.add_argument('-d', '--destroy', action='store_true')
parser.add_argument('-p', '--plan', action='store_true')
args = parser.parse_args()

if __name__ == "__main__":
  run()
