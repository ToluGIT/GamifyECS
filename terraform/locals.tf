locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
  passwddata = var.passwddata != null ? var.passwddata : data.aws_secretsmanager_random_password.test.random_password

  cluster_name = "${var.project_name}-${var.environment}-cluster"
  alb_name     = "${var.project_name}-${var.environment}-alb"
  service_name = "${var.project_name}-${var.environment}-service"
}

