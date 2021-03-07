environment="dev"
vpc_cidr= "10.0.0.0/16"
public_subnets_cidr_1=["10.0.0.0/24"]
public_subnets_cidr_2=["10.0.10.0/24"]
private_subnets_cidr_1=["10.0.16.0/20"]
private_subnets_cidr_2=["10.0.32.0/20"]
availability_zones=["us-east-1a", "us-east-1b"]
aws_tags={
    "application" = "mhdemo"
}
