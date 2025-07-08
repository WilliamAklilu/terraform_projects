resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availablity_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "public-${count.index+1}"
    }
  
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availablity_zones[count.index]
    tags = {
      Name = "private-${count.index+1}"
    }
  
}