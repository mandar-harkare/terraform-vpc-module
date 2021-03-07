# terraform-vpc-module
This module deploys a basic Web application on AWS. Following resources will be deployed if the values from terraform.tfvars are used

    1. VPC
    2. Internet Gateway
    3. 2 Public Subnets
    4. 2 Private Subnets
    5. Public Security Group
    6. Private Security Group
    7. 2 NAT Gateways
    8. Application Load Balancer
    9. Listner 
    10. Tagret Group
    11. Launch Configuration
    12. Auto Scaling Group
    13. Auto Scaling Group Policy
    14. Cloudwatch Alarm to trigger the scaling


## Prequisites
    *   Terraform12 (This module is tested on Terraform v0.12.30)
    *   Logged in to AWS Cli
    *   Environment Variables 
Details can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these (or legacy) environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. The AWS_DEFAULT_REGION and AWS_SESSION_TOKEN environment variables are also used, if applicable:


## Variables (terraform.tfvars)
    * environment: "dev" # dev|int|stage|pre|prod
    * vpc_cidr: "10.0.0.0/16"
    * public_subnets_cidr_1: ["10.0.0.0/24"]
    * public_subnets_cidr_2: ["10.0.10.0/24"]
    * private_subnets_cidr_1: ["10.0.16.0/20"]
    * private_subnets_cidr_2: ["10.0.32.0/20"]
    * availability_zones: ["us-east-1a", "us-east-1b"]
    * aws_tags: {
        "application" = "mhdemo"
      }
    * service_name: "mhdemo" (This will be used in every resource name, so would be easire to find out the resources after deployment.)


## Deploy
```
terraform init
terraform workspace new mhdemo-us-east-1-dev
terraform workspace select mhdemo-us-east-1-dev
terraform plan
terraform apply
```
```diff
- Note: After deployment, wait till the Target Groups's Health Checks passes!
```

## Architecture (High Availability / Multi A-Z)

![Assignment Architecture](./mastercard_architecture.PNG)
