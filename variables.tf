variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "hashitalks-africa2023"
}

variable "subnet_id" {
  description = "ID of subnet"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
  default    = ""
}


