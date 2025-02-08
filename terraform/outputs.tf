output "application_url" {
  description = "ALB DNS name for accessing the application"
  value       = aws_lb.main.dns_name
}
