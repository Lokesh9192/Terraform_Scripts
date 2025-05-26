provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0af9569868786b23a"
    instance_type = "t2.micro"
    tags = {
    Name = "HelloWorld"
  }
}
