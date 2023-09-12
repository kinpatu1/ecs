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

resource "aws_ecs_service" "bar" {
  name                = "bar"
  cluster             = aws_ecs_cluster.foo.id
  task_definition     = aws_ecs_task_definition.taskdef.arn
  scheduling_strategy = "REPLICA"
  desired_count       = "1"
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_in" {
  resource_id = "service/white-hart/bar"
  name = "ScaleInPolicy"
  policy_type = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown = "300"
    metric_aggregation_type = "Average"
    min_adjustment_magnitude = "0"
    step_adjustment {
      metric_interval_upper_bound = "0"
      scaling_adjustment = "-1"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_out" {
  resource_id = "service/white-hart/bar"
  name = "ScaleOutPolicy"
  policy_type = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown = "300"
    metric_aggregation_type = "Average"
    min_adjustment_magnitude = "0"
    step_adjustment {
      metric_interval_lower_bound = "0"
      scaling_adjustment = "1"
    }
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = "10"
  min_capacity = "3"
  resource_id = "service/white-hart/bar"
  role_arn = "arn:aws:iam::074708073377:role/ecsServiceRole"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}
