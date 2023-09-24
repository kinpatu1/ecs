resource "aws_secretsmanager_secret" "secretsmanager" {
  name = var.secretsmanager_name
}

resource "aws_secretsmanager_secret_version" "parameter" {
  secret_id     = aws_secretsmanager_secret.secretsmanager.id
  secret_string = <<-EOF
      {
        "HOST": "${var.host}",
        "USER": "${var.username}",
        "PASSWORD": "${var.password}",
        "DB_NAME": "${var.dbname}",
        "SLACK_NOTIFICATION": "${var.slack_notification}"
      }
    EOF
}