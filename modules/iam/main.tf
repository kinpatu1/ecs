output "role_arn_for_taskdef" {
  value = aws_iam_role.ecs_taskdef.arn
}

####################
#別アカウントのS3バケットポリシーにIAM role名を登録しているので、名前の変更は禁止
####################

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

resource "aws_iam_role_policy" "taskdef_policy" {
  name = var.policy_name_ecs_taskdef
  role = aws_iam_role.ecs_taskdef.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_taskdef" {
  role       = aws_iam_role.ecs_taskdef.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}