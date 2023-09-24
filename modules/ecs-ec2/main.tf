output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

resource "aws_ecs_task_definition" "taskdef" {
  family             = var.task_definition_name
  task_role_arn      = var.role_arn_for_taskdef
  execution_role_arn = var.role_arn_for_taskdef
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
        "environment" = [
          { "name" : "DB", "value" : "mysql" },
          { "name" : "EXCUTE_TYPE", "value" : "${var.execute_type}" },
          { "name" : "REGION_NAME", "value" : "ap-north-east1" },
          { "name" : "SECRET_MANGER_FLG", "value" : "1" },
          { "name" : "BUCKET_NAME", "value" : "${var.customer_bucket}" },
          { "name" : "FILE_SPLIT_NUM", "value" : "1000" },
          { "name" : "CLEANING", "value" : "0" },
          { "name" : "ENV", "value" : "aws" }
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

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  capacity_providers = ["${var.capacity_provider_name}"]


  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    ignore_changes = [
      setting
    ]
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = var.capacity_provider_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                = var.ecs_service_name
  cluster             = aws_ecs_cluster.ecs_cluster.id
  task_definition     = aws_ecs_task_definition.taskdef.arn
  scheduling_strategy = "REPLICA"
  desired_count       = "1"
  capacity_provider_strategy {
    base              = "0"
    capacity_provider = var.capacity_provider_name
    weight            = "1"
  }
}

