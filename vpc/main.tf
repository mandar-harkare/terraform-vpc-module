/*==== The VPC ======*/
resource "aws_vpc" "mhdemo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "mhdemo_ig" {
  vpc_id = aws_vpc.mhdemo_vpc.id
  tags = {
    Name        = "igw-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "mhdemo_nat_eip_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.mhdemo_ig]
}
resource "aws_eip" "mhdemo_nat_eip_2" {
  vpc        = true
  depends_on = [aws_internet_gateway.mhdemo_ig]
}
/* NAT */
resource "aws_nat_gateway" "mhdemo_nat_1" {
  allocation_id = aws_eip.mhdemo_nat_eip_1.id
  subnet_id     = element(aws_subnet.mhdemo_public_subnet_1.*.id, 0)
  depends_on    = [aws_internet_gateway.mhdemo_ig]
  tags = {
    Name        = "nat-${var.short_region}-${var.environment}-${var.service_name}-1"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "mhdemo_nat_2" {
  allocation_id = aws_eip.mhdemo_nat_eip_2.id
  subnet_id     = element(aws_subnet.mhdemo_public_subnet_2.*.id, 0)
  depends_on    = [aws_internet_gateway.mhdemo_ig]
  tags = {
    Name        = "nat-${var.short_region}-${var.environment}-${var.service_name}-2"
    Environment = var.environment
  }
}
/* Public subnets */
resource "aws_subnet" "mhdemo_public_subnet_1" {
  vpc_id                  = aws_vpc.mhdemo_vpc.id
  count                   = length(var.public_subnets_cidr_1)
  cidr_block              = element(var.public_subnets_cidr_1, count.index)
  availability_zone       = element(var.availability_zones, 0)
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, 0)}"
  }
}

resource "aws_subnet" "mhdemo_public_subnet_2" {
  vpc_id                  = aws_vpc.mhdemo_vpc.id
  count                   = length(var.public_subnets_cidr_2)
  cidr_block              = element(var.public_subnets_cidr_2, count.index)
  availability_zone       = element(var.availability_zones, 1)
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, 1)}"
  }
}

/* Private subnets */
resource "aws_subnet" "mhdemo_private_subnet_1" {
  vpc_id                  = aws_vpc.mhdemo_vpc.id
  count                   = length(var.private_subnets_cidr_1)
  cidr_block              = element(var.private_subnets_cidr_1, count.index)
  availability_zone       = element(var.availability_zones, 0)
  map_public_ip_on_launch = false
  tags = {
    Name        = "private-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, 0)}"
  }
}

resource "aws_subnet" "mhdemo_private_subnet_2" {
  vpc_id                  = aws_vpc.mhdemo_vpc.id
  count                   = length(var.private_subnets_cidr_2)
  cidr_block              = element(var.private_subnets_cidr_2, count.index)
  availability_zone       = element(var.availability_zones, 1)
  map_public_ip_on_launch = false
  tags = {
    Name        = "private-subnet-${var.short_region}-${var.environment}-${var.service_name}-${element(var.availability_zones, 1)}"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "mhdemo_private_1" {
  vpc_id = aws_vpc.mhdemo_vpc.id
  tags = {
    Name        = "private-route-table-${var.short_region}-${var.environment}-${var.service_name}-1"
  }
}
resource "aws_route_table" "mhdemo_private_2" {
  vpc_id = aws_vpc.mhdemo_vpc.id
  tags = {
    Name        = "private-route-table-${var.short_region}-${var.environment}-${var.service_name}-2"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "mhdemo_public" {
  vpc_id = aws_vpc.mhdemo_vpc.id
  tags = {
    Name        = "public-route-table-${var.short_region}-${var.environment}-${var.service_name}"
  }
}
resource "aws_route" "mhdemo_public_internet_gateway" {
  route_table_id         = aws_route_table.mhdemo_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mhdemo_ig.id
}
resource "aws_route" "mhdemo_private_nat_gateway_1" {
  route_table_id         = aws_route_table.mhdemo_private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mhdemo_nat_1.id
}
resource "aws_route" "mhdemo_private_nat_gateway_2" {
  route_table_id         = aws_route_table.mhdemo_private_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mhdemo_nat_2.id
}
/* Route table associations */
resource "aws_route_table_association" "mhdemo_public_1" {
  count          = length(var.public_subnets_cidr_1)
  subnet_id      = element(aws_subnet.mhdemo_public_subnet_1.*.id, 0)
  route_table_id = aws_route_table.mhdemo_public.id
}

resource "aws_route_table_association" "mhdemo_public_2" {
  count          = length(var.public_subnets_cidr_2)
  subnet_id      = element(aws_subnet.mhdemo_public_subnet_2.*.id, 0)
  route_table_id = aws_route_table.mhdemo_public.id
}

resource "aws_route_table_association" "mhdemo_private_1" {
  count          = length(var.private_subnets_cidr_1)
  subnet_id      = element(aws_subnet.mhdemo_private_subnet_1.*.id, 0)
  route_table_id = aws_route_table.mhdemo_private_1.id
}

resource "aws_route_table_association" "mhdemo_private_2" {
  count          = length(var.private_subnets_cidr_2)
  subnet_id      = element(aws_subnet.mhdemo_private_subnet_2.*.id, 0)
  route_table_id = aws_route_table.mhdemo_private_2.id
}

/*==== VPC's Security Groups ======*/
resource "aws_security_group" "mhdemo_public_sg" {
  name        = "sec-pblc-${var.short_region}-${var.environment}-${var.service_name}"
  description = "Public security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.mhdemo_vpc.id
  depends_on  = [aws_vpc.mhdemo_vpc]
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}

resource "aws_security_group" "mhdemo_private_sg" {
  name        = "sec-prvt-${var.short_region}-${var.environment}-${var.service_name}"
  description = "Private security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.mhdemo_vpc.id
  depends_on  = [aws_vpc.mhdemo_vpc]
  ingress {
    description = "HTTPs from LB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.mhdemo_public_sg.id]
  }

  ingress {
    description = "HTTP from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.mhdemo_public_sg.id]
  }

  tags = var.aws_tags
}
