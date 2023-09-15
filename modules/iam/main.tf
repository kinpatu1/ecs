resource "aws_iam_role" "ecs_taskdef" {
  name = var.role_name_ecs_taskdef

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = var.role_name_ecs_taskdef
  }
}