# DIYStackset

## Folders
* cli-solution - implements stacksets with local files and terraform open-source
* orchestration - implements the creation and configuration of TFC workspaces, 1 per account.
* resources - YAML specifications by AWS Account number.
* partner-pipeline - implements the IAM pipeline for partner accounts.
* saml-pipeline - implements the SAML shared-service account for federated-roles.
## Deploy IAM Objects (federated-roles & service-account, aka users)
This automation consumes the YAML specifications in the resources directory to create or correct drift of  federated-roles & service-account.


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
2. Set AWS variables...
```
export AWS_PROFILE=
```
Or...
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
3. Test AWS CLI configuration
```
aws sts get-caller-identity
```
4. Test your terraform credentials and confirm the state of orchestration is what you desire.
```
terraform login
cd git/DIYStackset/iam-kiosk/orchestration
terraform state list
```
5. Create terraform Variable Sets
* Create an org variable set TFC, add env var TFE_Token.
* Create an org variable-set named, Github, with var named, oauth_token_id.
* Create an org var-set named Tags, populate it with default values for the entire org.
..* Tags/AppID, Compliance, CRIS, DataClassification, Environment, Notify, Owner
* For each file in resources/*/*.tfvars, use the file contents to create an organizational variable set named, "account#-vars", ie 123133550781-vars.
..* set environment variables: AWS_ACCESS_KEY_ID,  AWS_SECRET_ACCESS_KEY
..* set the terraform variables
..* set tag env variables per account
7. Set your local terraform variables for aws, git and terraform environments.
..*TFC organization, project
..*github org, repo and branch name
..*aws saml_account_num
The remaining vars do not require changing.
```
cd orchestration
vim terraform.auto.tfvars
```
8. Deploy the orchestration.
```
terraform apply -auto-approve
```
This will create the workspace "orchestration" within the TFC organization.project that you specified.
That workspace will in-turn trigger the creation of 1 workspace per account.
Most workspaces will invoke the partner-pipeline whereas the SAML account's workspace invokes the saml-pipeline.
