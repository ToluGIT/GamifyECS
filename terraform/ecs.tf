resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name  
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name         = "${var.project_name}-container"
    image        = var.container_image
    essential    = true
    portMappings = [{ 
      containerPort = var.container_port 
      hostPort      = var.container_port 
    }]

    environment = [
      {
        name = "SPRING_DATASOURCE_URL"
        value = "jdbc:mysql://${aws_db_instance.main.endpoint}/${aws_db_instance.main.db_name}"
      },
      {
        name = "SPRING_DATASOURCE_USERNAME"
        value = aws_db_instance.main.username
      },
      {
        name = "SPRING_DATASOURCE_PASSWORD"
        value = aws_db_instance.main.password
      },
      {
        name = "ADMIN_USERNAME"
        value = var.admin_username  
      },
      {
        name = "ADMIN_PASSWORD"
        value = var.admin_password 
      }
    ]
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        "awslogs-group"  = aws_cloudwatch_log_group.ecs.name,
        "awslogs-region" = var.aws_region,
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = local.common_tags
}

resource "aws_ecs_service" "main" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [for subnet in aws_subnet.private_subnets : subnet.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${var.project_name}-container"
    container_port   = var.container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = local.common_tags
}

