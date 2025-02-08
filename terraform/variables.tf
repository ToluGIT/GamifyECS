variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
  default     = "toluid/mvngit:latest"
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
  default     = 8080
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "app-first"
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "ecs_cluster_name" {
  description = "Fixed ECS cluster name for CI/CD compatibility"
  type        = string
  default     = "app-cluster"
}

variable "ecs_service_name" {
  description = "Fixed ECS service name for CI/CD compatibility"
  type        = string
  default     = "app-first-service"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "unitgame"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "Admin username for the application"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for the application"
  type        = string
  sensitive   = true
}

variable "passwddata" {
  description = "Optional password for the RDS instance. If not provided, a random password will be generated."
  type        = string
  default     = null
}