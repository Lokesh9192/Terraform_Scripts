provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_id = "ami-0af9569868786b23a"
  enable_all = true
  instance_type = "t2.medium"
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
