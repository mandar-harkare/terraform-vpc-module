variable "service_name" {
  description = "The string service name."
  default     = "mastercard"
}

variable "stage" {
  description = "Environment for deployment."
  default     = "d"
}

variable "aws_region" {
  description = "Region for deployment."
  default     = "us-east-1"
}

variable "aws_region_map" {
  description = "Forcepoint AWS region name by AWS region"
  type        = "map"

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
  description = "Forcepint account code."
  default     = 365761988620
}

variable "stage_full_name" {
  description = "Full environment name for deployment."
  default     = "dev"
}

variable "aws_tags" {
  description = "variable name for tagging"
  type        = "map"
  default     = {
    "fp-application-version" = "unknown"
  }
}

variable "log_level" {
  description = "Log Level"
  default = "info"
}

variable "gateway_logging_level" {
  description = "The Api Gateway logging level, defaults to ERROR"
  default = "ERROR"
}
