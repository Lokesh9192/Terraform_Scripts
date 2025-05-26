variable "instance_type" {
  description = "This variable is refered to instance type value"
  type = string
  default = "t2.micro"
}

variable "ami_id" {
  description = "This variable is refered to ami value"
  type = string
}

variable "enable_all" {
  description = "Allow inbound traffic type"
  type        = bool
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "example" {
  name = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                # -1 means all protocols
    cidr_blocks = var.enable_all ? ["0.0.0.0/0"] : []
  }
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

