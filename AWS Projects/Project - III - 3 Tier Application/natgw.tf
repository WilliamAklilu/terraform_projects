resource "aws_eip" "nat" {
    tags = {
      Nasme = "nat-eip"
    }
  
}

resource "aws_nat_gateway" "gw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id
    tags = {
      Name = "NAT Gateway I"
    }
    depends_on = [ aws_eip.nat]
}

resource "aws_route" "private_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  
}