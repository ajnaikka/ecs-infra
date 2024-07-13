# create a VPC and a private subnet and a public subnet
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ecs_vpc"
  }
}

resource "aws_subnet" "ecs_public_subnet_1" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ecs_vpc_public_subnet_1"
  }
}

resource "aws_subnet" "ecs_public_subnet_2" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "ecs_vpc_public_subnet_2"
  }
}

resource "aws_subnet" "ecs_private_subnet_1" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ecs_private_subnet_1"
  }
}

resource "aws_subnet" "ecs_private_subnet_2" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "ecs_private_subnet_2"
  }
}

resource "aws_db_subnet_group" "ecs_db_subnet_group" {
  name       = "ecs_db_subnet_group"
  subnet_ids = [aws_subnet.ecs_private_subnet_1.id, aws_subnet.ecs_private_subnet_2.id]

  tags = {
    Name = "ecs_db_subnet_group"
  }
}
