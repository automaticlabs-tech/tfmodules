# Create Route53 Record to CloudFront
resource "aws_route53_record" "this" {
  name    = "www.automaticlabs.tech"
  type    = "CNAME"
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