variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "image_name" {}

variable "my_public_key" {}

variable "ip" {
  type = string
}