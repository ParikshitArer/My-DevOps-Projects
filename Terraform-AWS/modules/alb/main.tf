
# ==========================================
# APPLICATION LOAD BALANCER
# ==========================================

resource "aws_lb" "main" {
  name = substr(lower("${var.project_name}-alb"), 0, 32)

  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
  }
}


# ==========================================
# TARGET GROUP
# ==========================================

resource "aws_lb_target_group" "app" {
  name = substr(lower("${var.project_name}-tg"), 0, 32)

  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = var.environment
  }
}


# ==========================================
# TARGET GROUP ATTACHMENT
# ==========================================

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn

  target_id = var.ec2_instance_id
  port      = 80
}


# ==========================================
# HTTP LISTENER
# ==========================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Environment = var.environment
  }
}

