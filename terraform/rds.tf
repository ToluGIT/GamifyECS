resource "aws_db_instance" "main" {
  identifier        = "appfirst-db"   
  engine            = "mysql"
  engine_version    = "8.0.32"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  db_name           = var.db_name
  username          = "admin"
  password          = local.passwddata 

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false  # This remains false as it's already secure
  tags = local.common_tags
}

data "aws_secretsmanager_random_password" "test" {
  password_length = 12
  exclude_numbers = true
  exclude_characters  = "/@\\\" "
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "my-db-secret-${formatdate("YYYYMMDD", timestamp())}"
  description = "Secret for RDS database credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin",
    password = local.passwddata
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "appfirst-db-subnet"
  subnet_ids = [for subnet in aws_subnet.isolated_subnets : subnet.id]
  tags       = local.common_tags
}