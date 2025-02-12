resource "aws_lb" "main" {
  name               = "app-first-albname" 
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnets["us-east-1a"].id, aws_subnet.public_subnets["us-east-1b"].id]  # Using public subnets for ALB
  security_groups    = [aws_security_group.alb.id]
  tags               = local.common_tags
}

resource "aws_lb_target_group" "main" {
  name        = "app-first-tg"  
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id 

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
