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