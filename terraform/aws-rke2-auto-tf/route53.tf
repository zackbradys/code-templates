#resource "aws_route53_zone" "aws_rke2_zone" {
#  name = var.domain
#  force_destroy = true
#  private_zone = false
#  comment = "AWS RKE2 Route53 Hosted Zone"
#}

resource "aws_route53_record" "aws_rke2_record_rke2" {
  #zone_id     = aws_route53_zone.aws_rke2_zone.zone_id
  zone_id     = "Z089762637TAJS9TTNWZL"
  name        = ""
  type        = "A"
  ttl         = 300
  records     = [aws_elb.aws_rke2_lb.dns_name]
}

resource "aws_route53_record" "aws_rke2_record_ingress" {
  # zone_id = aws_route53_zone.aws_rke2_zone.zone_id
  zone_id     = "Z089762637TAJS9TTNWZL"
  name        = "*"
  type        = "CNAME"
  ttl         = 300
  records     = [aws_elb.aws_rke2_ingress_lb.dns_name]
}