resource "aws_ecs_task_definition" "taskdef_service_go" {
  family                = var.task_definition_name
  container_definitions = jsonencode(
[
        {
            "name": "miki_container_name",
            "image": "httpd",
            "essential": true,
            "memory": 200,
            "portMappings": [
                {
                    "containerPort": 80,
                    "protocol": "tcp"
                }
            ]
      }
])

  requires_compatibilities = ["EC2"]
  network_mode = "bridge"
}

