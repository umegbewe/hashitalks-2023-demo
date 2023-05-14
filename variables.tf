variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "hashitalks-africa2023"
}

variable "subnet_id" {
  description = "ID of subnet"
  type        = string
  default     = "subnet-0220d56dab1974a74"
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
  default    = "vpc-0ccf5652831d3cb7c"
}


