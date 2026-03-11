variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Existing subnet ID"
}

variable "key_pair_name" {
  type        = string
  description = "Existing EC2 keypair name"
}

# 2 instances: different sizes
variable "instance_types" {
  type        = list(string)
  description = "Instance types for 2 EC2"
  default     = ["t3.micro", "t3.small"]
}

# 2 instances: different root disk sizes
variable "disk_sizes" {
  type        = list(number)
  description = "Root disk sizes for 2 EC2 (GB)"
  default     = [30, 50]
}
