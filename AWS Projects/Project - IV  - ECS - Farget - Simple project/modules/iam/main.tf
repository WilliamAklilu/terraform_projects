# modules/iam/main.tf
# Defines IAM roles for ECS.
resource "aws_iam_role" "ecs_task_execution_role" {
  name_prefix        = "${var.project_name}-ecs-task-execution-"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.project_name}-ecs-task-execution-role"
    Environment = "FreeTier"
  }
}

# Attach the managed policy for ECS task execution.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}