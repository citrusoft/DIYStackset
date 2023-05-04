aws_region       = "us-west-2"
aws_role         = "Administrator"
saml_account_num = "782391863272"
ss_account_num   = "782391863272"
target_account_id= "123133550781"

role_file_paths     = [ "./test/resources/*/federated-roles/*.yaml" ]
user_file_paths     = [ "./test/resources/*/service-accounts/*.yaml" ]
# role_file_paths     = [ "./test/resources/123133550781/federated-roles/DEV_Ops.yaml" ]
# user_file_paths     = [ "./test/resources/123133550781/service-accounts/SVC-DEV-Ops.yaml" ]

AppID              = "2781"                   #"Identify the application this asset belongs to by its AMPS APP ID.Format = APP-####"
Environment        = "Dev"                    #Dev, Test, QA, Prod (only one)
DataClassification = "Internal"               #Public, Internal, Confidential, Restricted, Privileged (only one)
CRIS               = "Low"                    #"Cyber Risk Impact Score High, Medium, Low (only one)"
Notify             = ["tahv@pge.com"]         #Who to notify for system failure or maintenance. Should be a group or list of email addresses."
Owner              = ["tahv", "def2", "ghi3"] #"List three owners of the system, as defined by AMPS Director, Client Owner and IT Leadeg"
Compliance         = ["None"]                 #Identify assets with compliance requirements SOX, HIPAA, CCPA or None
optional_tags = {
}