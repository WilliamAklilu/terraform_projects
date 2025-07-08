data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/health_check.py"
  output_path = "${path.module}/lambda/health_check.zip"

}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }]
    }
  )

}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"


}

resource "aws_lambda_function" "health_check" {
    function_name = "ec2-health-check"
    filename = data.archive_file.lambda_zip.output_path
    source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
    handler = "health_check.lambda_handler"
    runtime = "python3.11"
    role = aws_iam_role.lambda_exec.arn
    timeout = 10
    environment {
      variables = {
        INSTANCE_ID = aws_instance.ubuntu.id
      }
    }
  
}

resource "aws_cloudwatch_event_rule" "two_min" {
    name = "every-two-min"
    schedule_expression = "rate(2 minutes)"
  
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.two_min.name
    arn = aws_lambda_function.health_check.arn
    target_id = "LambdaCheck"
  
}

resource "aws_lambda_permission" "cloudwatch_invoke" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.health_check.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.two_min.arn
  
}