variable "subnet_prefix" {
  description = "cidr block of subnet"
}

variable "vpc_prefix" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "bucket_name" {
  description = "Name of Terraform state file"
  type        = string
}

variable "environment" {
  description = "Environmet name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of dynamoDB table"
  type        = string
}