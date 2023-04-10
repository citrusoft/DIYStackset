import subprocess

import boto3

def init():
  subprocess.run(f"terraform init", check=True, shell=True)

def get_accounts():
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

def run():
  init()
  for account in get_accounts():
    if account != "424304752381":
      continue
    if not workspace_exists(account):
      create_workspace(account)
    switch_to_workspace(account)
    plan(account)
    apply(account)

if __name__ == "__main__":
  run()

