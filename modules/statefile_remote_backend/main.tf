provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.example.id]
    associate_public_ip_address = true
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

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "reddy-lokesh-salapala-terraform" # change this
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}