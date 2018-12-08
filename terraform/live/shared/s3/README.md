store state files in S3

once bucket created in order to store state 

-- OLD version 
terraform remote config -backend=s3 
    -backend-config="bucket=terraform-training-state-s3" 
    -backend-config="key=shared/s3/terraform.tfstate" 
    -backend-config="region=eu-west-2" -backend-config="encrypt=true"

-- NEW version
use backend