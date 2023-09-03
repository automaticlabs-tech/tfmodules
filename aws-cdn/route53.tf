resource "aws_route53_zone" "this" {
  name = "automaticlabs.tech"
}

# data "aws_route53_zone" "this" {
#   name         = "${local.route53_base_domain}."
#   private_zone = local.route53_private_zone
# }

# Create Route53 Record to CloudFront
resource "aws_route53_record" "this" {
  name    = "automaticlabs.tech"
  type    = "A"
  zone_id = aws_route53_zone.this.zone_id
  #zone_id = data.aws_route53_zone.domain_zone.zone_id
  #name    = local.cdn_domain != "" ? local.cdn_domain : data.aws_route53_zone.domain_zone.name
  
  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.this
  ]
}