resource "aws_security_group" "web_sg" {
    name = "web-sg"
    description = "Allow SSH & HTTP"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.allowed_ssh_cidr]
    }

    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {Name="Web-SG"}

    
  
}

resource "aws_security_group" "app_sg" {
    name = "app-sg"
    description = "Allow 5000 from web-sg"
    vpc_id = aws_vpc.main.id

    ingress  {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
       security_groups = [aws_security_group.web_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {Name="App-SG"}
}

resource "aws_security_group" "rds_sg" {
    name = "rds-sg"
    description = "Allow MySQL from app_sg"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.app_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {Name="RDS-SG"}
}