module "vpc" {
  source = "./vpc"

  short_region          = lookup(var.aws_region_map, var.aws_region)
  aws_region            = "${var.aws_region}"
  service_name          = "${var.service_name}"
  aws_tags              = "${var.aws_tags}"
  account_code          = "${var.account_code}"
  environment           = "${var.environment}"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnets_cidr   = "${var.public_subnets_cidr}"
  private_subnets_cidr  = "${var.private_subnets_cidr}"
  availability_zones    = "${var.availability_zones}"
}
