output "table_name" {
  value = "${module.dynamodb.table_name}"
}

output "aws_region" {
  value = "${var.aws_region}"
}