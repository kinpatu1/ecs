resource "aws_secretsmanager_secret" "secretsmanager" {
  name = var.secretsmanager_name
}

resource "aws_secretsmanager_secret_version" "parameter" {
  secret_id     = aws_secretsmanager_secret.secretsmanager.id
  secret_string = <<-EOF
      {
        "crud_ecs_task_definition": "${var.task_def}",
        "crud_ecs_subnet_1": "${var.subnet_1}",
        "crud_ecs_subnet_2": "${var.subnet_2}",
        "crud_ecs_sg_name": "${var.sg_name}",
        "crud_ecs_container_name": "${var.container_name}",
        "cruster_name": "${var.cruster_name}"
      }
    EOF
}