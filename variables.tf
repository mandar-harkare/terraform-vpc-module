variable "service_name" {
  description = "The string service name."
  default     = "mhdemo"
}

variable "stage" {
  description = "Environment for deployment."
  default     = "d"
}

variable "environment" {
  description = "Environment for deployment."
  default     = "d"
}

variable "aws_region" {
  description = "Region for deployment."
  default     = "us-east-1"
}

variable "aws_region_map" {
  description = "Forcepoint AWS region name by AWS region"
  type        = map

  default = {
    ap-south-1     = "aps1"
    eu-west-3      = "euw3"
    eu-west-2      = "euw2"
    eu-west-1      = "euw1"
    ap-northeast-2 = "apne2"
    ap-northeast-1 = "apne1"
    sa-east-1      = "sae1"
    ca-central-1   = "cac1"
    ap-southeast-1 = "apse1"
    ap-southeast-2 = "apse2"
    eu-central-1   = "euc1"
    us-east-1      = "use1"
    us-east-2      = "use2"
    us-west-1      = "usw1"
    us-west-2      = "usw2"
  }
}

variable "account_code" {
  description = "AWS account code."
  default     = 0000000000
}

variable "stage_full_name" {
  description = "Full environment name for deployment."
  default     = "dev"
}

variable "aws_tags" {
  description = "variable name for tagging"
  type        = map
  default     = {
    "application" = "mhdemo"
  }
}

variable "vpc_cidr" {
  description = "VPC cidr"
  default = "info"
}

variable "public_subnets_cidr" {
  description = "Public Subnets cidr"
  default = ""
}

variable "private_subnets_cidr" {
  description = "Private Subnets cidr"
  default = ""
}

variable "availability_zones" {
  description = "Availability zines for subnets"
  default = ""
}

