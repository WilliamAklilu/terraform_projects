resource "aws_db_subnet_group" "rds" {
  name = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {Name="RDS-Subnet-Group"}

}

resource "aws_db_instance" "rds" {
    identifier = "rds-i"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = var.db_instance_class
    allocated_storage = var.db_allocated_storage
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.rds.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    skip_final_snapshot = true
    publicly_accessible = false
    tags = {Name="RDS-I"}
  
}