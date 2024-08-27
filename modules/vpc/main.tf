 resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    tags = {
        Name =  "my-vpc"
    }
    lifecycle {
        create_before_destroy = false
  }

}

resource "aws_internet_gateway" "my_igw" {
   vpc_id = aws_vpc.my_vpc.id

   tags = {
    Name = "my-igw"
   }

     lifecycle {
    create_before_destroy = false
  }
 }


resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.my_igw]
  domain   = "vpc"

  tags = {
    Name = "elastic-ip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
    subnet_id = aws_subnet.web_public_subnets[1].id
    allocation_id = aws_eip.eip.id
   

    tags = {
      Name = "nat-gw"
    }

  depends_on = [aws_internet_gateway.my_igw]
}

data "aws_availability_zones" "avail_zone" {
}

resource "aws_subnet" "web_public_subnets" {
    count = var.web_pub_sub_count
   vpc_id = aws_vpc.my_vpc.id
   cidr_block = "10.0.${1 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = true

    tags = {
        Name = "web-subnet${count.index + 1}"
    }
}


resource "aws_subnet" "app_private_subnets" {
    count = var.private_sub_count
   vpc_id = aws_vpc.my_vpc.id
   cidr_block = "10.0.${3 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = false

    tags = {
        Name = "private-subnet${count.index + 1}"
    }
}

resource "aws_subnet" "db_private_subnets" {
    count = var.private_sub_count
   vpc_id = aws_vpc.my_vpc.id
   cidr_block = "10.0.${5 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = false

    tags = {
        Name = "db-subnet${count.index + 1}"
    }

}

resource "aws_db_subnet_group" "db_subnet_group" {
    count = var.db_subnet_group == true ? 1 : 0
    name       = "db-subnet-group"
 subnet_ids = aws_subnet.db_private_subnets[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

 resource "aws_route_table" "public_rt" {
   vpc_id = aws_vpc.my_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
   }

   tags = {
     Name = "public-rt"
   }
 }


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "web_rt_asso" {
    count = var.web_pub_sub_count
    subnet_id = aws_subnet.web_public_subnets.*.id[count.index]
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_rt_asso" {
   count = var.private_sub_count
    subnet_id = aws_subnet.app_private_subnets.*.id[count.index]
      route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_rt_asso_2" {
    count = var.private_sub_count
    subnet_id = aws_subnet.db_private_subnets.*.id[count.index]
    route_table_id = aws_route_table.private_rt.id
}
