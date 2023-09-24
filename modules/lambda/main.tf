resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.11"
  timeout       = "60"

  filename         = data.archive_file.function_source.output_path
  source_code_hash = data.archive_file.function_source.output_base64sha256

  environment {
    variables = {
      CONTAINER_NAME           = var.CONTAINER_NAME
      CRUD_FOR_ECS_SECRET_NAME = var.CRUD_FOR_ECS_SECRET_NAME
      CRUSTER_NAME             = var.CRUSTER_NAME
      SG_NAME                  = var.SG_NAME
      SUBNET_1                 = var.SUBNET_1
      SUBNET_2                 = var.SUBNET_2
      TASK_DEFINITION          = var.TASK_DEFINITION
    }
  }
  vpc_config {
    subnet_ids         = [var.subnet_lambda1, var.subnet_lambda2]
    security_group_ids = [var.security_group]
  }

  tags = {
    for_CRUD_verification = "for CRUD verification"
  }
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "${path.module}/functions"
  output_path = "${path.module}/archive/function.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = var.role_name_lambda_exec

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = var.role_name_lambda_exec
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = var.lambda_policy_name
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:RunTask",
          "iam:PassRole",
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}