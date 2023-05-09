#!/usr/bin/env python3
'''
# Filename    : terrastacks.py
# Date        : 10 Apr 2021
# Author      : Tommy Hunt (tahv@pge.com)
# Description : stackset-esque functionality for your Terraform code.
#               Simply deploying common infrastructure across AWS accts.
'''
__author__ = 'Tommy Hunt'
__version__ = '0.1.0'
__license__ = 'PGE'

import argparse
import glob
import os
import subprocess
import re
import json

# DEFAULT_RESOURCE_PATH = '/Users/TAHV/tmp/resources'
DEFAULT_RESOURCE_PATH = '/Users/TAHV/git/aws-lz-iam/cscoe-iam-kiosk/test/resources/'


def init():
    '''Initializes terraform state and cache.'''
    subprocess.run('terraform init', check=True, shell=True)


def get_files_from_dir() -> map:
    '''returns list of yaml-file-paths'''
    paths = glob.glob(args.path2resources +
                      '**/federated-roles/*.yaml', recursive=False)
    paths = paths + glob.glob(args.path2resources +
                              '**/service-accounts/*.yaml', recursive=True)
    for path in paths:
        print(path)
    # Filter only files
    files = {}
    for path in paths:
        if os.path.isfile(path):
            account_list = re.findall('[0-9]{12}', path)
            if len(account_list) == 0:
                continue  # how to report this user-error?
            elements = path.split('/')
            if len(elements) < 3:
                continue
            account = account_list[0]
            kind = elements[len(elements) - 2]
            if kind not in ['federated-roles', 'service-accounts']:
                continue
            if account in files.keys():
                files[account][kind].append(path)
            else:
                files[account] = {
                    'federated-roles': [],
                    'service-accounts': []
                }
                files[account][kind].append(path)
    # print(json.dumps(files, indent=2))
    return files


def workspace_exists(account) -> bool:
    '''does workspace exist? returns bool'''
    completed_process = subprocess.run(
        f'terraform workspace list | grep {account}', check=False, shell=True)
    return completed_process.returncode == 0


def create_workspace(account):
    '''create a tfc workspace named with account id.'''
    subprocess.run(
        f'terraform workspace new {account}', check=True, shell=True)


def switch_to_workspace(account):
    '''switch to the given workspace named with account id.'''
    subprocess.run(
        f'terraform workspace select {account}', check=True, shell=True)


def plan(account, role_file_paths, user_file_paths):
    '''tfc plan'''
    command = f'terraform plan -var target_account_id={account} \
            -var role_file_paths=\'{json.dumps(role_file_paths)}\' \
            -var user_file_paths=\'{json.dumps(user_file_paths)}\''
    print(command)
    subprocess.run(command, check=True, shell=True)


def apply(account, role_file_paths, user_file_paths):
    '''tfc apply'''
    command = f'terraform apply -var target_account_id={account} \
            -var role_file_paths=\'{json.dumps(role_file_paths)}\' \
            -var user_file_paths=\'{json.dumps(user_file_paths)}\' -auto-approve'
    print(command)
    subprocess.run(command, check=True, shell=True)


def destroy(account, role_file_paths, user_file_paths):
    '''tfc destroy'''
    command = f'terraform destroy -var target_account_id={account} \
            -var role_file_paths=\'{json.dumps(role_file_paths)}\' \
            -var user_file_paths=\'{json.dumps(user_file_paths)}\' -auto-approve'
    print(command)
    subprocess.run(command, check=True, shell=True)


def run():
    '''entry point'''
    init()

    for account, paths in get_files_from_dir().items():
        if not workspace_exists(account):
            create_workspace(account)
        switch_to_workspace(account)
        if args.plan:
            plan(account, paths['federated-roles'], paths['service-accounts'])
        if args.apply:
            apply(account, paths['federated-roles'], paths['service-accounts'])
        if args.destroy:
            destroy(account, paths['federated-roles'], paths['service-accounts'])


# GLOBALS
parser = argparse.ArgumentParser(
    prog='terrastacks',
    description='stackset-esque functionality for your Terraform code.',
    epilog='Simply deploying common infrastructure across AWS accts.')
group = parser.add_mutually_exclusive_group()
group.add_argument('-a', '--apply', action='store_true')
group.add_argument('-d', '--destroy', action='store_true')
parser.add_argument('-p', '--plan', action='store_true')
parser.add_argument('path2resources', nargs='?', default=DEFAULT_RESOURCE_PATH)
args = parser.parse_args()

if __name__ == '__main__':
    run()
