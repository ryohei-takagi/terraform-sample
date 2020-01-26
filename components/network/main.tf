# VPC
resource "aws_vpc" "default" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "sample-${terraform.workspace}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "sample-public-route-table-${terraform.workspace}"
  }
}

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "sample-private-route-table-0-${terraform.workspace}"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "sample-private-route-table-1-${terraform.workspace}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "sample-internet-gateway-${terraform.workspace}"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.default.id
  destination_cidr_block = "0.0.0.0/0"
}

# Public Subnet
resource "aws_subnet" "public_0" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.1.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sample-public-subnet-0-${terraform.workspace}"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "sample-public-subnet-1-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public_0" {
  subnet_id = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet
resource "aws_subnet" "private_0" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.1.10.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sample-private-subnet-0-${terraform.workspace}"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.1.11.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "sample-private-subnet-1-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_0" {
  subnet_id = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_0.id
}