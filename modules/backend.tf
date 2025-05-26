terraform {
  backend "s3" {
    bucket         = "reddy-lokesh-salapala-terraform" # change this
    key            = "lokeshreddy/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}