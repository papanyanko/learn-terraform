provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "terraform-state-31415"
  db_remote_state_key = "prod/data-storage/mysql/terraform.tfstate"
}

module "data_storage" {
  source = "../../../modules/data-storage/mysql"

  db_password = "????"
  db_username = "????"
}