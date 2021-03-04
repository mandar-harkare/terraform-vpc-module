/*==== The VPC ======*/
resource "aws_vpc" "mastercard_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "mastercard_ig" {
  vpc_id = "${aws_vpc.mastercard_vpc.id}"
  tags = {
    Name        = "igw-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "mastercard_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.mastercard_ig]
}
/* NAT */
resource "aws_nat_gateway" "mastercard_nat" {
  allocation_id = "${aws_eip.mastercard_nat_eip.id}"
  subnet_id     = "${element(aws_subnet.mastercard_public_subnet.*.id, 0)}"
  depends_on    = [aws_internet_gateway.mastercard_ig]
  tags = {
    Name        = "nat-${var.short_region}-${var.environment}-${var.service_name}"
    Environment = "${var.environment}"
  }
}
/* Public subnet */
resource "aws_subnet" "mastercard_public_subnet" {
  vpc_id                  = "${aws_vpc.mastercard_vpc.id}"
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr,   count.index)}"
  availability_zone       = "${element(var.availability_zones,   count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, count.index)}"
  }
}
/* Private subnet */
resource "aws_subnet" "mastercard_private_subnet" {
  vpc_id                  = "${aws_vpc.mastercard_vpc.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones,   count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "private-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, count.index)}"
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "mastercard_private" {
  vpc_id = "${aws_vpc.mastercard_vpc.id}"
  tags = {
    Name        = "private-route-table-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "mastercard_public" {
  vpc_id = "${aws_vpc.mastercard_vpc.id}"
  tags = {
    Name        = "public-route-table-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
resource "aws_route" "mastercard_public_internet_gateway" {
  route_table_id         = "${aws_route_table.mastercard_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mastercard_ig.id}"
}
resource "aws_route" "mastercard_private_nat_gateway" {
  route_table_id         = "${aws_route_table.mastercard_private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.mastercard_nat.id}"
}
/* Route table associations */
resource "aws_route_table_association" "mastercard_public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.mastercard_public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.mastercard_public.id}"
}
resource "aws_route_table_association" "mastercard_private" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.mastercard_private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.mastercard_private.id}"
}
/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name        = "sg-${var.short_region}-${var.environment}-${var.service_name}"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.mastercard_vpc.id}"
  depends_on  = [aws_vpc.mastercard_vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Environment = "${var.environment}"
  }
}
