terraform {
  backend "s3" {
    bucket = "terraform-state-31415"
    key = "stage/data-storage/mysql/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "data_storage" {
  source = "../../../../modules/data-storage/mysql"

  db_name = "dbstage"
  instance_class = "db.t3.micro"
  db_password = var.db_password
  db_username = var.db_username
}