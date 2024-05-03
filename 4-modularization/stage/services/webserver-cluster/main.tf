provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-state-31415"
  db_remote_state_key = "stage/data-storage/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  max_size = 2
}