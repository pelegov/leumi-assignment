provider "aws" {
  region = "us-east-1"
}

### Create SG with ingress and egress rules

resource "aws_security_group" "sg_test_ec2" {
  name        = "test_ec2_sg"
  description = "Allow HTTP traffic from specific IP"
  vpc_id      = aws_vpc.selected_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["91.231.246.50/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Create Elastic IP in the VPC 
resource "aws_eip" "vip_eip" {
  vpc = true
}

### Create The ec2 instance and install apache

resource "aws_instance" "test_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-aws-key"

  security_groups = [aws_security_group.sg_test_ec2.name]

  associate_public_ip_address = true
  public_ip                   = aws_eip.vip_eip.public_ip

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  tags = {
    Name = "Test EC2"
  }
}

### Associate the eip to the instance

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.test_ec2.id
  allocation_id = aws_eip.vip_eip.id
}

data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = ["TEST-SPOKE-VPC"]
  }
}