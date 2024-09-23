# Output backend_rds ALB URL
output "rds_alb_url" {
  value = "http://${aws_lb.alb.dns_name}/test_connection/"
}

