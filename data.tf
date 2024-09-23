data "aws_security_group" "alb_sg" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}"]
  }

  filter {
    name   = "tag:stage"
    values = ["${var.stage}"]
  }

  filter {
    name   = "tag:used_by"
    values = ["public_alb"]
  }

  vpc_id = var.vpc_id
}

output "alb_security_group_id" {
  value = data.aws_security_group.alb_sg.id
}


data "aws_security_group" "ecs_sg" {
  filter {
    name   = "tag:name"
    values = ["${var.app_name}"]
  }

  filter {
    name   = "tag:stage"
    values = ["${var.stage}"]
  }

  filter {
    name   = "tag:used_by"
    values = ["private_ecs"]
  }

  vpc_id = var.vpc_id
}

output "ecs_security_group_id" {
  value = data.aws_security_group.ecs_sg.id
}

data "aws_s3_bucket" "cloudfront_bucket" {
  bucket = "experior-${var.app_name}-${var.stage}-static-site-bucket"
}


# Data source to fetch an existing ECS cluster
data "aws_ecs_cluster" "private_cluster_name" {
  cluster_name = var.aws_ecs_cluster_name
}

# Output the ECS Cluster ARN (which is effectively the ECS cluster ID)
output "ecs_cluster_arn" {
  value = data.aws_ecs_cluster.private_cluster_name.arn
}

