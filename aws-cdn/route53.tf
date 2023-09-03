# data "aws_route53_zone" "this" {
#   name         = "${local.route53_base_domain}."
#   private_zone = local.route53_private_zone
# }


# # Create Route53 Record to CloudFront
# resource "aws_route53_record" "this" {
#   name    = local.cdn_domain != "" ? local.cdn_domain : data.aws_route53_zone.domain_zone.name
#   type    = "A"
#   zone_id = data.aws_route53_zone.domain_zone.zone_id

#   alias {
#     name                   = aws_cloudfront_distribution.cloudfront.domain_name
#     zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
#     evaluate_target_health = false
#   }

#   depends_on = [
#     aws_cloudfront_distribution.cloudfront
#   ]
# }