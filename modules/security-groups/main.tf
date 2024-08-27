resource "aws_security_group" "web_lb_sg" {
    vpc_id = var.vpc_id
    description = "Allow traffic from the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ip]
    }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
    }
        tags = {
          Name = "web-elb-sg"
        }
}


resource "aws_security_group" "web_sg" {
    vpc_id = var.vpc_id
    description = "Allow traffic from web loadbalancer and ssh"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups =  [aws_security_group.web_lb_sg.id]
    }

 ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
    }
        tags = {
          Name = "web-sg"
        }
}


resource "aws_security_group" "app_lb_sg" {
    vpc_id = var.vpc_id
    description = "Allow traffic from web sg"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups =  [aws_security_group.web_sg.id]  
    } 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
       Name = "app-elb-sg"
    }
}


resource "aws_security_group" "app_sg" {
    vpc_id = var.vpc_id
    description = "Allow traffic from app loadbalancer and ssh from web instance"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.web_sg.id]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.app_lb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

        tags = {
            Name = "app-sg"
        }
}

 resource "aws_security_group" "db_sg" {
   vpc_id = var.vpc_id
   description = "Allow traffic from app instance"

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

    tags = {
        Name = "db-sg"
    }
 }

