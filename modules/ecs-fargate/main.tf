output "security_group_application_id" {
  value = aws_security_group.application.id
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
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

resource "aws_ecs_task_definition" "taskdef" {
  network_mode       = "awsvpc"
  cpu                = 1024
  memory             = 4096
  family             = var.task_definition_name
  task_role_arn      = var.role_arn_for_taskdef
  execution_role_arn = var.role_arn_for_taskdef
  container_definitions = jsonencode(
    [
      {
        "name" : var.container_name,
        "image" : "${var.image}:latest",
        "essential" : true,
        "memory" : 4096,
        "memoryReservation": 4096,
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
          { "name" : "REGION_NAME", "value" : "ap-northeast-1" },
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

  requires_compatibilities = ["FARGATE"]
}

resource "aws_security_group" "application" {
  description = var.security_group_application
  vpc_id      = var.vpc_id
  name        = var.security_group_application
  tags = {
    Name = var.security_group_application
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    cidr_blocks      = []
    from_port        = "22"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    self             = false
    to_port          = "22"
    security_groups  = [var.security_group_gateway]
  }
}