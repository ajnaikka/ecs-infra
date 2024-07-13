# Create a security group for the EFS
resource "aws_security_group" "ecs_efs_sg" {
  name        = "ecs_efs_sg"
  description = "Allow NFS traffic from the ECS tasks"
  vpc_id      = aws_vpc.ecs_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_efs_sg"
  }
}


resource "aws_security_group_rule" "efs_inbound" {
  type            = "ingress"
  from_port       = 2049
  to_port         = 2049
  protocol        = "tcp"
  security_group_id = aws_security_group.ecs_efs_sg.id


  source_security_group_id = aws_security_group.ecs_alb_sg.id
}

resource "aws_security_group_rule" "efs_inbound_bastion" {
  type            = "ingress"
  from_port       = 2049
  to_port         = 2049
  protocol        = "tcp"
  security_group_id = aws_security_group.ecs_efs_sg.id


  source_security_group_id = aws_security_group.bastion.id
}
