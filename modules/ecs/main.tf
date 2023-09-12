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

### ここから命名きちんとする

resource "aws_ecs_cluster" "foo" {
  name = "white-hart"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "go" {
  iam_role                           = "ecsServiceRole"
  cluster                            = aws_ecs_cluster.foo.id
  desired_count                      = "1"
  launch_type                        = "EC2"
  name                               = "miki"
  task_definition                    = "flow-taskdef"

  deployment_controller {
    type = "ECS"
  }
}
