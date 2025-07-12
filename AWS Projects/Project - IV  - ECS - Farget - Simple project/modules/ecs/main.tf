# modules/ecs/main.tf
# Defines the ECS cluster, task definition, service, and security group.
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name        = "${var.project_name}-ecs-cluster"
    Environment = "FreeTier"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.project_name}-ecs-task-sg-"
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic to ECS tasks only from ALB"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    security_groups = [var.alb_security_group_id] # Allow traffic only from ALB's security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Needed for pulling images, health checks, etc.
  }

  tags = {
    Name        = "${var.project_name}-ecs-task-sg"
    Environment = "FreeTier"
  }
}

resource "aws_ecs_task_definition" "nginx_app" {
  family                   = "${var.project_name}-nginx-task"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name        = "nginx"
      image       = var.container_image
      cpu         = var.container_cpu
      memory      = var.container_memory
      essential   = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/nginx-app"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-nginx-task-def"
    Environment = "FreeTier"
  }
}

# Create a CloudWatch Log Group for ECS task logs
resource "aws_cloudwatch_log_group" "nginx_app_log_group" {
  name              = "/ecs/nginx-app"
  retention_in_days = 7 # Keep logs for 7 days

  tags = {
    Name        = "${var.project_name}-nginx-log-group"
    Environment = "FreeTier"
  }
}


resource "aws_ecs_service" "nginx_app_service" {
  name            = "${var.project_name}-nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = 1 # Keep a single task for Free Tier
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true # Required for Fargate tasks in public subnets
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "nginx"
    container_port   = var.container_port
  }

  # Ensure the ALB and its target group are fully provisioned before creating the service
  depends_on = [
    aws_security_group.ecs_tasks,
     ]

  tags = {
    Name        = "${var.project_name}-nginx-service"
    Environment = "FreeTier"
  }
}

