provider "aws" {
  alias = "ap-south-1"
  region = "ap-south-1"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"

}

resource "aws_instance" "ec2_instance" {
    ami = "ami-0af9569868786b23a"
    instance_type = "t2.micro"
    tags = {
    Name = "HelloWorld"
  }
    provider = "aws.ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0953476d60561c955"
    instance_type = "t2.micro"
    tags = {
    Name = "HelloWorld"
  }
    provider = "aws.us-east-1"
}