variable "ami" {
  description = "The AMI to use in the cluster"
  type = string
  default = "ami-0fb653ca2d3203ac1"
}

variable "server_port" {
  description = "The port the server will use or HTTP requests"
  type = number
  default = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  default = "t3.micro"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  default = 2
  type = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  default = 10
  type = number
}

variable "server_text" {
  type =  string
  default = "Hello, World"
}