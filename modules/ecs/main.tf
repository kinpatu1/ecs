resource "aws_ecs_task_definition" "taskdef_service_go" {
  family                = var.task_definition_name
  taskRoleArn = "arn:aws:iam::074708073377:role/ecsTaskExecutionRole"
  executionRoleArn = "arn:aws:iam::074708073377:role/ecsTaskExecutionRole"
  container_definitions = jsonencode(
[
        {
            "name": var.container_name,
            "image": var.image,
            "essential": true,
            "memory": 200,
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp"
                }
            ]
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/miki",
                    "awslogs-region": "ap-northeast-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
      }
])

  requires_compatibilities = ["EC2"]
}

