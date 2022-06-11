resource "aws_vpc" "main" {
  cidr_block           = local.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${local.unique_name}-vpc"
    Environment = "${var.environment}"
    DateTime    = "${timestamp()}"
    CreateBy    = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(local.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "public-subnet-${count.index}"
    Environment = "${var.environment}"
    DateTime    = "${timestamp()}"
    CreateBy    = "Terraform"
    Security    = "Public"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(local.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "private-subnet-${count.index}"
    Environment = "${var.environment}"
    DateTime    = "${timestamp()}"
    CreateBy    = "Terraform"
    Security    = "Private"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.unique_name}-igw"
    Environment = "${var.environment}"
    DateTime    = "${timestamp()}"        
  }
}

resource "aws_eip" "eip_nat" {
  count = length(local.public_subnet_cidr)
  vpc = true
  tags = {
    Name = "${local.unique_name}-nat-eip"
    Environment  = "${var.environment}"        
    DateTime = "${timestamp()}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(local.public_subnet_cidr)
  allocation_id = "${element(aws_eip.eip_nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"

  tags = {
    Name = "${local.unique_name}-nat-gw-${count.index}"
    Environment  = "${var.environment}"        
    DateTime = "${timestamp()}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  
  tags = {
    Name = "${local.unique_name}-public-rtb"
    Environment  = "${var.environment}"        
    DateTime = "${timestamp()}"
  }
}

resource "aws_route_table_association" "public_association" {
  count = length(aws_subnet.public_subnet.*.id)
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table" "private_route_table" {
  count = length(aws_subnet.private_subnet.*.id)
  vpc_id = aws_vpc.main.id

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }
  
  tags = {
    Name = "${local.unique_name}-private-rtb-${count.index}"
    Environment  = "${var.environment}"        
    DateTime = "${timestamp()}"
  }
}

resource "aws_route_table_association" "private_association" {
  count = length(aws_subnet.private_subnet.*.id)
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}