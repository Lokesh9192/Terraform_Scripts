variable "instance_type" {
  description = "This variable is refered to instance type value"
  type = string
  default = "t2.micro"
}

variable "ami_id" {
  description = "This variable is refered to ami value"
  type = string
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

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

