# Create an EFS file system
resource "aws_efs_file_system" "ecs_efs" {
  creation_token = "ecs-efs"

  tags = {
    Name = "ecs-efs"
  }
}

# Create a mount target in the private subnet 1
resource "aws_efs_mount_target" "ecs_efs_mount_target_1" {
  file_system_id  = aws_efs_file_system.ecs_efs.id
  subnet_id       = aws_subnet.ecs_private_subnet_1.id
  security_groups = [aws_security_group.ecs_efs_sg.id]
  
}

# Create a mount target in the private subnet 2.
resource "aws_efs_mount_target" "ecs_efs_mount_target_2" {
  file_system_id  = aws_efs_file_system.ecs_efs.id
  subnet_id       = aws_subnet.ecs_private_subnet_2.id
  security_groups = [aws_security_group.ecs_efs_sg.id]
  
}
