resource "aws_security_group" "ec2_sg" {
  name        = "ec2_private_sg"
  description = "Allow SSH from Specific IP"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "ubuntu" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "t2"  #provide SSh Key Name here
  associate_public_ip_address = false
  user_data                   = <<EOF
            #!/bin/bash
            apt update -y 
            EOF

  tags ={
    name = "Private EC2"
  }


}
