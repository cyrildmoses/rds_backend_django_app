
# ECS Service 
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-${var.stage}-service"
  cluster         = data.aws_ecs_cluster.private_cluster_name.arn
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [data.aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "${var.app_name}-${var.stage}-ecs-task"
    container_port   = var.ecs_task_port
  }

  depends_on = [aws_lb_listener.backend_rds_listener]

}



# Auto-scaling target for ECS service
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 3                      # Max number of tasks
  min_capacity       = 1                      # Min number of tasks
  resource_id        = "service/${data.aws_ecs_cluster.private_cluster_name.cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto-scaling policy for both scaling in and out based on CPU utilization
resource "aws_appautoscaling_policy" "cpu_scaling_policy" {
  name                   = "${var.app_name}-${var.stage}-cpu-scaling"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension     = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace      = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0  # Target CPU utilization percentage
  }
}