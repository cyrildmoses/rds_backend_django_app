# Create DB subnet group using private subnets
resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name       = "rds-private-subnet-group-${var.app_name}-${var.stage}"
  subnet_ids = var.private_subnet_ids
}

# Security group for RDS (no public access)
resource "aws_security_group" "rds_sg" {
  name        = "rds-${var.app_name}-${var.stage}"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow incoming traffic from ECS tasks on port 5432 for PostgreSQL database access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [data.aws_security_group.ecs_sg.id]  # Only allow traffic from within the VPC
  }

  egress {
    description = "Allows all outbound traffic to all IP addresses on all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS instance in the private subnet
resource "aws_db_instance" "postgres_free_tier" {
  identifier = "postgres-${var.app_name}-${var.stage}"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t4g.micro"
  db_name                 = "mydb"
  username             = "db_admin_user"
  availability_zone    = "${var.region}a"
  password             = var.db_password  # Make sure this is managed securely
  db_subnet_group_name = aws_db_subnet_group.rds_private_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false  # Ensure RDS is private
  multi_az             = false
}