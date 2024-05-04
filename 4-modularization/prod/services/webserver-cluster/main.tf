terraform {
  backend "s3" {
    bucket = "terraform-state-31415"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "terraform-state-31415"
  db_remote_state_key = "prod/data-storage/mysql/terraform.tfstate"
}
