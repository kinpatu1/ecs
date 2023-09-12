resource "aws_ecs_task_definition" "taskdef" {
  family             = var.task_definition_name
  task_role_arn      = "arn:aws:iam::${var.account}:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::${var.account}:role/ecsTaskExecutionRole"
  container_definitions = jsonencode(
    [
      {
        "name" : var.container_name,
        "image" : "${var.image}:latest",
        "essential" : true,
        "memory" : 200,
        "portMappings" : [
          {
            "containerPort" : 80,
            "hostPort" : 80,
            "protocol" : "tcp"
          }
        ]
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "/ecs/${var.project}",
            "awslogs-region" : "ap-northeast-1",
            "awslogs-stream-prefix" : "${var.project}"
          }
        }
      }
  ])

  requires_compatibilities = ["EC2"]
}

