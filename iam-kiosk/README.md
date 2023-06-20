# DIYStackset

## Deploy IAM Objects (federated-roles & service-account, aka users)
This automation will create and correct drift of the federated-roles & service-account specified with yaml files in the resources folder.
You specify the resources folder with variables, resource_folder AND resource_path.

### Pre-reqs
* aws cli
* aws credentials
* terraform cli
* terraform cloud account & organizaton

### Steps
1. Set Terraform Cloud variables.
```
export TF_CLOUD_ORGANIZATION=
export TF_PROJECT=
export TF_WORKSPACE=
```
2. Set AWS variables.
```
export AWS_PROFILE=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
3. Test AWS CLI configuration
```
aws sts get-caller-identity
```
4. Confirm terraform credentials and the state of orchestration
```
terraform login
cd git/DIYStackset/iam-kiosk/orchestration
terraform state list
```
5. Create terraform Variable Sets
Github/oauth_token_id
Account/aws_region
Account/aws_role
Account/role_file_paths
Account/target_account_id
Account/saml_acount_num
Account/user_file_paths
Tags/AppID, Compliance, CRIS, DataClassification, Environment, Notify, Owner
6. Create Environment variable sets
Account/AWS_ACCESS_KEY_ID
Account/AWS_SECRET_ACCESS_KEY
TFC/TFE_Token
7. Set your local terraform variables
git and terraform environments.
organizations and branch name.
```
vim terraform.auto.tfvars
```
8. Deploy the orchestration.
```
cd git/DIYStackset/iam-kiosk/orchestration
terraform apply -auto-approve
```
This will create the workspace "orchestration" within the TFC organization.project that you specified.
That workspace will in-turn trigger the creation of 1 workspace per account.
Of course, accounts are specified with a directory name in the resources folder.