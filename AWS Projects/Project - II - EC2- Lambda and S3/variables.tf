variable "region" {
    default = "us-east-1"
  
}

variable "project_name" {
    default = "awsproject212166300"
  
}

variable "my_ip" {
    description = "Public IP for the SSh access"
    type = string
    default = "20.20.20.20/32"
  
}

variable "ami_id" {
  default = "ami-020cba7c55df1f615"
}