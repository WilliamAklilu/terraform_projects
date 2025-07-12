# modules/alb/main.tf
# Defines the Application Load Balancer, target group, and listener.
resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-sg-"
  vpc_id      = var.vpc_id
  description = "Allow HTTP inbound traffic to ALB from anywhere"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = "FreeTier"
  }
}

resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = "FreeTier"
  }
}

resource "aws_lb_target_group" "ecs_tasks" {
  name_prefix          = "ecs-tg"
  port                 = var.container_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip" # Required for Fargate

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30 # Default is 30 seconds
    timeout             = 5  # Default is 5 seconds
    healthy_threshold   = 2  # Default is 5
    unhealthy_threshold = 2  # Default is 2
  }

  tags = {
    Name        = "${var.project_name}-ecs-tg"
    Environment = "FreeTier"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tasks.arn
  }

  tags = {
    Name        = "${var.project_name}-alb-listener"
    Environment = "FreeTier"
  }
}


