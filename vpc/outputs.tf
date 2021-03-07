output "vpc_id" {
  value = "${aws_vpc.mhdemo_vpc.id}"
}

output "private_subnet_id_1" {
  value = "${element(aws_subnet.mhdemo_private_subnet_1.*.id, 0)}"
}

output "private_subnet_id_2" {
  value = "${element(aws_subnet.mhdemo_private_subnet_2.*.id, 0)}"
}

output "public_subnet_id_1" {
  value = "${element(aws_subnet.mhdemo_public_subnet_1.*.id, 0)}"
}

output "public_subnet_id_2" {
  value = "${element(aws_subnet.mhdemo_public_subnet_2.*.id, 0)}"
}

output "private_sg_id" {
  value = "${aws_security_group.mhdemo_private_sg.id}"
}

output "public_sg_id" {
  value = "${aws_security_group.mhdemo_public_sg.id}"
}