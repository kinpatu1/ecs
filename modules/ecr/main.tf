output "repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}