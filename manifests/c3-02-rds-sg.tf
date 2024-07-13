resource "aws_security_group" "ecs_rds_sg" {
  name        = "ecs_rds_sg"
  description = "Allow inbound traffic from the VPC CIDR block"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ecs_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_rds_sg"
  }
}
