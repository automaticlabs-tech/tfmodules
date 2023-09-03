resource "aws_acm_certificate" "this" {
  #domain_name       = local.cdn_domain != "" ? local.cdn_domain : data.aws_route53_zone.domain_zone.name
  domain_name        = "automaticlabs.tech"
  validation_method = "DNS"

#   tags = {
#     Stage   = local.stage,
#     Service = local.service
#   }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]

  depends_on = [
    aws_acm_certificate.this
  ]

  timeouts {
    create = "10m"
  }
}

# Add Certificate Validation Records on Route53
resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  #zone_id         = data.aws_route53_zone.domain_zone.zone_id
  zone_id         = aws_route53_zone.this.zone_id
}