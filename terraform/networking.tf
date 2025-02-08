resource "aws_default_vpc" "main" {
  tags = local.common_tags
}

resource "aws_default_subnet" "az_a" {
  availability_zone = "us-east-1a"
  tags              = local.common_tags
}

resource "aws_default_subnet" "az_b" {
  availability_zone = "us-east-1b"
  tags              = local.common_tags
}

resource "aws_db_subnet_group" "main" {
  name       = "appfirst-db-subnet"
  subnet_ids = [aws_default_subnet.az_a.id, aws_default_subnet.az_b.id]
  
  tags = local.common_tags
}