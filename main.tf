# Existing VPC
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

# Existing Subnet
data "aws_subnet" "existing_subnet" {
  id = var.subnet_id
}

# Existing Key Pair
data "aws_key_pair" "existing" {
  key_name = var.key_pair_name
}

# Ubuntu 22.04 AMI (x86_64)
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Security Group
resource "aws_security_group" "ssh" {
  name        = "ssh-sg"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Better: your public IP only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances (2 instances)
resource "aws_instance" "ec2" {
  count         = 2
  ami           = data.aws_ami.ubuntu_2204.id
  instance_type = var.instance_types[count.index]
  subnet_id     = data.aws_subnet.existing_subnet.id
  key_name      = data.aws_key_pair.existing.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = var.disk_sizes[count.index]
  }

  tags = {
    Name = "cicd-ec2-${count.index + 1}"
  }
}
