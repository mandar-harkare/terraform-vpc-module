module "vpc" {
  source = "./vpc"

  short_region          = lookup(var.aws_region_map, var.aws_region)
  aws_region            = "${var.aws_region}"
  service_name          = "${var.service_name}"
  aws_tags              = "${var.aws_tags}"
  account_code          = "${var.account_code}"
  environment           = "${var.environment}"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnets_cidr_1 = "${var.public_subnets_cidr_1}"
  private_subnets_cidr_1= "${var.private_subnets_cidr_1}"
  public_subnets_cidr_2 = "${var.public_subnets_cidr_2}"
  private_subnets_cidr_2= "${var.private_subnets_cidr_2}"
  availability_zones    = "${var.availability_zones}"
}

module "elb" {
  source = "./elb"

  short_region          = lookup(var.aws_region_map, var.aws_region)
  aws_region            = "${var.aws_region}"
  service_name          = "${var.service_name}"
  aws_tags              = "${var.aws_tags}"
  environment           = "${var.environment}"
  asg_id                = "${module.asg.asg_id}"
  vpc_id                = "${module.vpc.vpc_id}"
  public_sg_id          = "${module.vpc.public_sg_id}"
  public_subnet_ids     = ["${module.vpc.public_subnet_id_1}", "${module.vpc.public_subnet_id_2}"]
}

module "asg" {
  source = "./asg"

  short_region          = lookup(var.aws_region_map, var.aws_region)
  aws_region            = "${var.aws_region}"
  service_name          = "${var.service_name}"
  aws_tags              = "${var.aws_tags}"
  elb_id                = "${module.elb.elb_id}"
  environment           = "${var.environment}"
  private_sg_id         = "${module.vpc.private_sg_id}"
  private_subnet_ids    = ["${module.vpc.private_subnet_id_1}", "${module.vpc.private_subnet_id_2}"]
  availability_zones    = "${var.availability_zones}"
}
