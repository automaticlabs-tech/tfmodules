
variable "s3_name" {
  type = string
  detault = "s3_backend"
}

variable "s3_tags" {
  type = map(string)
}