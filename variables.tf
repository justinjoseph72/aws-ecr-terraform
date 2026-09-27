variable "creator_tag" {
  description = "Value of the Creator tag"
  type        = string
  default     = "tf-ecr-learning"
}

variable "running_profile" {
  description = "AWS profile to use when running terraform commands"
  type        = string
  default     = "admin-sso"
}

variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}


variable "project_name" {
  description = "Name prefix used for tagging resources"
  type        = string
  default     = "tf-ecr-learning"
}

variable "ec2_instance_type" {
  description = "EC2 instance type to use for the web server"
  type        = string
  default     = "t3.micro"
}

variable "ecr_expiry_days" {
  description = "Number of days after which ECR images should expire"
  type        = number
  default     = 14
}

variable "ecr_untagged_expiry_days" {
  description = "Number of days after which ECR untagged images should expire"
  type        = number
  default     = 1
}
