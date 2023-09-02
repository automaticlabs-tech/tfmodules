variable "default_az" {
  type = string
}

variable "secondary_az" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "enable_dns_hostnames" {
  type = string
}

variable "enable_dns_support" {
  type = string

}

variable "vpc_tags" {
  type = map(string)
}


variable "private_subnet_tags" {
  type = map(string)
  default = {
    "Name"   = "private_subnet"
    "Access" = "private"
    "Tier"   = "poc"
  }
}

variable "public_subnet_tags" {
  type = map(string)
  default = {
    "Name"   = "public_subnet"
    "Access" = "public"
    "Tier"   = "poc"
  }
}

variable "enable_private_subnet" {
  type = bool
}

variable "enable_public_subnet" {
  type = bool
}