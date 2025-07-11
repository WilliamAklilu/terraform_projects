resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "PUB-RT"
    }
  
}

resource "aws_route" "public_internet" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}

resource "aws_route_table_association" "public_assoc" {
    count = length(aws_subnet.public)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name="PRV-RT"
    }
  
}

resource "aws_route_table_association" "private_assoc" {
  
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}