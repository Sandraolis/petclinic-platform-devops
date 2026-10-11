resource "aws_vpc" "petclinic_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "petclinic_igw" {
  vpc_id = aws_vpc.petclinic_vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

resource "aws_subnet" "petclinic_public_subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.petclinic_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.project}-${var.environment}-public-${count.index + 1}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table" "petclinic_public_route_table" {
  vpc_id = aws_vpc.petclinic_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.petclinic_igw.id
  }

  tags = {
    Name = "${var.project}-${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "petclinic_public_route_association" {
  count = length(aws_subnet.petclinic_public_subnet)

  subnet_id      = aws_subnet.petclinic_public_subnet[count.index].id
  route_table_id = aws_route_table.petclinic_public_route_table.id
}
