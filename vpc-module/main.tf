#
# VPC resources
#

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }

  tags {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "PublicRouteTable"
  }
}

resource "aws_subnet" "private" {
  lifecycle {
    create_before_destroy = true
  }

  count = "${length(split(",", var.private_subnet_cidr_blocks))}"

  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${element(split(",", var.private_subnet_cidr_blocks), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"

  tags {
    Name = "PrivateSubnet"
  }
}

resource "aws_subnet" "public" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.public_subnet_cidr_blocks}"
  availability_zone       = "${var.availability_zones}"
  map_public_ip_on_launch = true

  tags {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.public_subnet_cidr_blocks))}"

  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

#
# NAT resources
#

resource "aws_eip" "nat" {
  vpc = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {

  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"

  depends_on = ["aws_internet_gateway.default"]

  lifecycle {
    create_before_destroy = true
  }
}

#
# Bastion resources
#

//resource "aws_security_group" "bastion" {
//  vpc_id = "${aws_vpc.default.id}"
//
//  tags {
//    Name = "sgBastion"
//  }
//}
//
//resource "aws_security_group_rule" "bastion_ssh_ingress" {
//  type = "ingress"
//  from_port = 22
//  to_port = 22
//  protocol = "tcp"
//  cidr_blocks = ["${var.external_access_cidr_block}"]
//  security_group_id = "${aws_security_group.bastion.id}"
//}
//
//resource "aws_security_group_rule" "bastion_ssh_egress" {
//  type = "egress"
//  from_port = 22
//  to_port = 22
//  protocol = "tcp"
//  cidr_blocks = ["0.0.0.0/0"]
//  security_group_id = "${aws_security_group.bastion.id}"
//}
//
//resource "aws_security_group_rule" "bastion_http_egress" {
//  type = "egress"
//  from_port = 80
//  to_port = 80
//  protocol = "tcp"
//  cidr_blocks = ["0.0.0.0/0"]
//  security_group_id = "${aws_security_group.bastion.id}"
//}
//
//resource "aws_security_group_rule" "bastion_https_egress" {
//  type = "egress"
//  from_port = 443
//  to_port = 443
//  protocol = "tcp"
//  cidr_blocks = ["0.0.0.0/0"]
//  security_group_id = "${aws_security_group.bastion.id}"
//}
//
//resource "aws_instance" "bastion" {
//  ami                         = "${var.bastion_ami}"
//  availability_zone           = "${element(split(",", var.availability_zones), 0)}"
//  instance_type               = "${var.bastion_instance_type}"
//  key_name                    = "${var.key_name}"
//  monitoring                  = true
//  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
//  subnet_id                   = "${aws_subnet.public.id}"
//  associate_public_ip_address = true
//
//  tags {
//    Name = "Bastion"
//  }
//}