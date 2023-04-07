variable "ami" {
  type = string
  default = "ami-007855ac798b5175e"
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
  default = null
}

variable "spot" {
  type = bool
}

variable "ondemand" {
  type = bool
}

variable "spot_price" {
  type = string
}

variable "key_name" {
  type = string
}

variable "wait_for_fulfillment" {
  type = string
}

variable "instance_qtd" {
  type = number
}

variable "ec2_tags" {
  type = map(string)
}

variable "associate_public_ip_address" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}
