#Backend_RDS ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.app_name}-${var.stage}-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_execution_iam_role_arn

  container_definitions = jsonencode([{
    name      = "${var.app_name}-${var.stage}-ecs-task"
    image     = var.backend_rds_ecr_image
    cpu       = 256
    memory    = 512
    essential = true
    environment = [
        {
          name  = "CORS_ALLOWED_ORIGINS"
          value = "http://${data.aws_s3_bucket.cloudfront_bucket.website_endpoint},http://${var.cloudfront_endpoint}"
        },
        {
          name  = "DB_NAME"
          value = var.postgres_db_name
        },
        {
          name  = "DB_HOST"
          value = split(":", aws_db_instance.postgres_free_tier.endpoint)[0]
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_USER"
          value = var.postgres_db_user
        }
      ]
    portMappings = [{
      containerPort = var.ecs_task_port
      hostPort      = var.ecs_task_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.app_name}-${var.stage}-ecs-task"
        "awslogs-region"        = "${var.region}"
        "awslogs-stream-prefix" = "ecs"
        "awslogs-create-group"  = "true"
        "mode"                  = "non-blocking"
        "max-buffer-size"       = "25m"
      }
    }
  }])

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

}