variable "region" {
    default = "us-east-1"
  
}

variable "availablity_zones" {
    type = list(string)
    default= ["us-east-1a", "us-east-1b"]
    
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
     
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
    
}

variable "private_subnet_cidrs" {
    type = list(string)
    default = [ "10.0.3.0/24", "10.0.4.0/24" ]
  
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "db_instance_class" {
    default = "db.t3.micro"
  }

  variable "db_allocated_storage" {
    default = 20
  }

  variable "db_name" {
    default = "appdb"
    
  }

  variable "db_username" {
    default = "admin"
    
  }

  variable "db_password" {
    default = "SecurePass123"
    sensitive = true

  }

  variable "allowed_ssh_cidr" {
    default = "0.0.0.0/0"
  }