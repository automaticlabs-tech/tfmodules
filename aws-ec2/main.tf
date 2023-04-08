  resource "aws_instance" "this" {
    count = var.ondemand ? var.instance_qtd : 0

    ami           = var.ami
    instance_type = var.instance_type

    subnet_id                   = var.subnet_id
    associate_public_ip_address = var.associate_public_ip_address 
    security_groups             = var.security_groups

    key_name      = var.key_name
    tags          = "${merge (var.ec2_tags)}"

  }

  resource "aws_spot_instance_request" "this" {
    count = var.spot ? var.instance_qtd : 0

    ami             = var.ami    
    instance_type   = var.instance_type

    subnet_id                   = var.subnet_id
    security_groups             =  var.security_groups 
    associate_public_ip_address = var.associate_public_ip_address 
    
    key_name               = var.key_name

    spot_price             = var.spot_price
    wait_for_fulfillment   = var.wait_for_fulfillment 

    tags = "${merge (var.ec2_tags) }"
  }

resource "aws_security_group" "allow_http_https" {
  name          = "allow_http_https"
  description   = "Allow HTTP and HTTPS from Anywhere"
  vpc_id        = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_https"
  }
}