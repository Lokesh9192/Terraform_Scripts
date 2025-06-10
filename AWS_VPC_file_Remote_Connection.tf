provider "aws" {
    region = "ap-south-1"
}
variable "cidr" {
  default =  "10.0.0.0/16"
}

resource "aws_key_pair" "key" {
  key_name   = "Network"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_main_route_table_association" "RTA" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id  # Replace with your actual VPC or use hardcoded VPC ID

  ingress {
    description      = "Allow all inbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "example-sg"
  }
}

resource "aws_instance" "ec2" {
    ami = "ami-0af9569868786b23a"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key.key_name
    vpc_security_group_ids = [ aws_security_group.example.id ]
    subnet_id = aws_subnet.main.id
    tags = {
    Name = "HelloWorld"
  }
    connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ec2-user/app.py"  # Replace with the path on the remote instance
  }  
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",  # Update package lists (for ubuntu)
      "sudo yum install -y python3-pip",  # Example package installation
      "cd /home/ec2-user",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  } 
}
