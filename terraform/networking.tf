resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = local.common_tags
}

resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.main.id
  for_each   = var.private_subnets
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value)
  availability_zone = each.key
  tags       = merge(local.common_tags, {
    Name = "${var.project_name}-private-${each.key}"
    Tier = "Private"
  })
}

resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.main.id
  for_each   = var.public_subnets
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value)
  availability_zone = each.key
  map_public_ip_on_launch = true  # Add this lin
  depends_on = [aws_db_instance.main]
  tags       = merge(local.common_tags, {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "Public"
  })
}

resource "aws_subnet" "isolated_subnets" {
  vpc_id     = aws_vpc.main.id
  for_each   = var.isolated_subnets
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value)
  availability_zone = each.key
  tags       = merge(local.common_tags, {
    Name = "${var.project_name}-isolated-${each.key}"
    Tier = "Isolated"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = local.common_tags
}

resource "aws_eip" "nat" {
  domain = "vpc"  
  tags = local.common_tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[keys(aws_subnet.public_subnets)[0]].id
  depends_on = [aws_internet_gateway.main, aws_subnet.public_subnets]
  tags          = local.common_tags
}

# Route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Add this to networking.tf - Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}