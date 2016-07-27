resource "aws_security_group" "allow_all_outbound" {
  name = "allow_all_outbound"
  description = "Allow all outbound traffic"
  vpc_id = "${aws_vpc.default.id}"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_all_inbound" {
  name = "allow_all_inbound"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.default.id}"

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_cluster" {
  name = "allow_cluster"
  description = "Allow all traffic within cluster"
  vpc_id = "${aws_vpc.default.id}"

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }
}

resource "aws_security_group" "allow_all_ssh" {
  name = "allow_all_ssh"
  description = "Allow all inbound SSH traffic"
  vpc_id = "${aws_vpc.default.id}"

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_inbound_graphite" {
  name = "allow_inbound_graphite"
  description = "Allow inbound traffic on the graphite udp port"
  vpc_id = "${aws_vpc.default.id}"

  ingress = {
    from_port = 8125
    to_port = 8125
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "dummy_policy_dependency" {
  depends_on = ["aws_iam_policy_attachment.ecs_elb"]
}