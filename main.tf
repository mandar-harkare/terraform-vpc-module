module "vpc" {
  source = "./vpc"

  short_region              = "${lookup(var.aws_region_map, var.aws_region)}"
  stage                 = "${var.stage}"
  aws_region            = "${var.aws_region}"
  service_name          = "${var.service_name}"
  lmb_arn               = "${module.lmb.ews_lmb_function}"
  hosted_zone_id        = "${var.hosted_zone_id}"
  domain_name           = "${var.domain_name}"
  sub_domain_name       = "${local.sub_domain_name}"
  domain_certificate    = "${var.polaris_infrastructure_dns_certificate_arn}"
  aws_tags           = "${var.aws_tags}"
  account_code   = "${var.account_code}"
  gateway_logging_level = "${var.gateway_logging_level}"
}
