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
