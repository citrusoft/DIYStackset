
## Git configuration
github_repo        = "DIYStackset"
github_org         = "citrusoft"
branch             = "1account1ws"
oauth_token_id     = null  # Specify this with environment variable, TF_VAR_oauth_token_id
resource_folder    = "iam-kiosk/resources"
resource_path      = "../resources"

## TFC configuration
organization       = "citrusoft"
project_name       = "iam-kiosk"
root_workspace     = "orchestration"
config_auto_apply  = true
drift_detection    = true
tags               = [ "ccoe", "cscoe", "iam-kiosk" ] # these are TFC tags, not AWS

## AWS configuration
saml_account_num   = "782391863272"
