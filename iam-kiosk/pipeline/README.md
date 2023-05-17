# cscoe-iam-kiosk

+ Pre-requisites: +
* aws cli2, bash, python3
* pip3 packages: glob, json, os, subprocess
* IAM Role that can assume IAMPipelineRole
* aws credentials and valid STS token, 

## Setup
* Install python3 and packages
```pip3 --trusted-host pypi.org --trusted-host files.pythonhosted.org install install -r requirements.txt```
* Install aws cli 2
* Sign-on, See https://github.com/pgetech/aws-auth-saml-federation-cli
* Set your variables in terraform.auto.tfvars
* Check the sanity of your terraform configuration.
```
terraform init
terraform validate
```
### Plan
```
./scripts/terrastacks.py -p <optionally provide path to resources folder>
```
### Apply
```
./scripts/terrastacks.py -a <optionally provide path to resources folder>
```
### Destroy
```
./scripts/terrastacks.py -d <optionally provide path to resources folder>
```


## Output

### yamlint-feedback
Reports the exitcode of yamllint evaluation(s) of the given yaml. Reports either valid or invalid.

### null_resource.validate_policy.findings
This is the json output of AWS' validate-policy API; it's feedback on errors in the json.

### filenames
The filenames discovered which are to be processed.
