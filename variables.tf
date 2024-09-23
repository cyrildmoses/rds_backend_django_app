variable "db_password" {
  description = "Password for DB"
  default     = "Markham-2024" 
}

# Variables

variable "app_name" {
  type        = string
  description = "Applciation Name"
  default     = "aws"
}

variable "region" {
  type        = string
  description = "AWS Region Name"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to use"
  default     = "vpc-01eba9fec92ad9863"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
  default     = ["subnet-013778321d0959dca", "subnet-09717d760978ee9a8"]
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS"
  default     = ["subnet-05dae9f756ad8570f", "subnet-0406c63c8cecd09fc"]
}

variable "backend_rds_ecr_image" {
  type        = string
  description = "Docker image for backend-rds ECS task"
  #default     = "333279433522.dkr.ecr.ap-southeast-2.amazonaws.com/ecs-ecr-poc-1"
  default = "010526284247.dkr.ecr.us-west-1.amazonaws.com/backend_rds"
}

variable "ecs_task_port" {
  type        = number
  default     = 8000
  description = "Port where the ECS application listens"
}

variable "postgres_db_name" {
  type = string
  description = "RDS postgres database name"
  default = "mydb"
}

variable "postgres_db_user" {
  type = string
  description = "RDS postgres db user"
  default = "db_admin_user"
}

variable "cloudfront_endpoint" {
  type = string
  description = "cloudfront endpoint"
  default = "d2i7byttb0mklq.cloudfront.net"
}

variable "aws_ecs_cluster_name" {
  type = string
  description = "ecs cluster name where the application will be deployed"
  default = "web-ecs-cluster-webapp-4-prod"
}

variable "task_execution_iam_role_arn" {
  type = string
  description = "ecs task execution iam role arn"
  default = "arn:aws:iam::010526284247:role/webapp-4-prod-ecs_task_execution_role"
}
