resource "aws_route_table" "ecs_public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name = "ecs_public_route_table"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "ecs_nat_eip"
  }
}

# NAT Gateway to be placed in Public Subnet 1
resource "aws_nat_gateway" "ecs_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.ecs_public_subnet_1.id

  tags = {
    Name = "ecs_nat_gateway"
  }
}

# Route table for private subnet to route traffic via NAT Gateway
resource "aws_route_table" "ecs_private_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_nat_gateway.id
  }

  tags = {
    Name = "ecs_private_route_table"
  }
}

# Associate public subnet 1 with the new route table
resource "aws_route_table_association" "ecs_public_route_table_association_1" {
  subnet_id      = aws_subnet.ecs_public_subnet_1.id
  route_table_id = aws_route_table.ecs_public_route_table.id
}

# Associate public subnet 2 with the new route table
resource "aws_route_table_association" "ecs_public_route_table_association_2" {
  subnet_id      = aws_subnet.ecs_public_subnet_2.id
  route_table_id = aws_route_table.ecs_public_route_table.id
}

# Associate private subnet 1 with the new route table
resource "aws_route_table_association" "ecs_private_route_table_association_1" {
  subnet_id      = aws_subnet.ecs_private_subnet_1.id
  route_table_id = aws_route_table.ecs_private_route_table.id
}

# Associate private subnet 2 with the new route table
resource "aws_route_table_association" "ecs_private_route_table_association_2" {
  subnet_id      = aws_subnet.ecs_private_subnet_2.id
  route_table_id = aws_route_table.ecs_private_route_table.id
}
