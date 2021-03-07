# terraform-vpc-module

## Prequisites
    * Terraform12
    * Logged in to AWS Cli
    * Environment Variables (Details can be found [here] (https://registry.terraform.io/providers/hashicorp/aws/latest/docs))
    You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these (or legacy) environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. The AWS_DEFAULT_REGION and AWS_SESSION_TOKEN environment variables are also used, if applicable:


## Deploy
```
terraform init
terraform workspace new mhdemo-us-east-1-dev
terraform workspace select mhdemo-us-east-1-dev
terraform plan
terraform apply
```

## Architecture (High Availability / Multi A-Z)

![Assignment Architecture](./mastercard_architecture.PNG)
