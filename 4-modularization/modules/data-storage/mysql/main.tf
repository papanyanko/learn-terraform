provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-runnning"
  engine = "mysql"
  allocated_storage = 10
  instance_class = var.instance_class
  skip_final_snapshot = true
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
}
