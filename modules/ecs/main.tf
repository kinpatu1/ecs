resource "aws_ecs_task_definition" "service" {
  family = var.task_definition_name
}