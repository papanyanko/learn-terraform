variable "db_username" {
  description = "The username for the database"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "The password for the database"
  type = string
  sensitive = true
}

variable "db_name" {
  description = "The name of the database"
  type = string
}

variable "instance_class" {
  description = "The class of the database instance"
  type = string
  default = "db.t3.micro"
}