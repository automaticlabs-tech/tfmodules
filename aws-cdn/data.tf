# Get AWS Account ID
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name         = "${local.route53_base_domain}."
  private_zone = local.route53_private_zone
}