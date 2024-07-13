# Fetch the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Security group for the bastion host to allow SSH from your IP
resource "aws_security_group" "bastion" {
  name        = "BastionSG"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.ecs_vpc.id 
}

# Generate a random password for the "odoo" user
resource "random_password" "odoo_db_password" {
  length  = 16
  special = true
}

# Store the password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "odoo_db_password" {
  name = "odoo_db_password"
}

resource "aws_secretsmanager_secret_version" "odoo_db_password" {
  secret_id     = aws_secretsmanager_secret.odoo_db_password.id
  secret_string = random_password.odoo_db_password.result
}


# Bastion EC2 instance
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = var.bastion_key_name

  vpc_security_group_ids = [aws_security_group.bastion.id]

  subnet_id = aws_subnet.ecs_public_subnet_1.id

  associate_public_ip_address = true
 
  tags = {
    Name = "BastionHost"
  }
}

# Output the Bastion Host public IP for easy access
output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}
