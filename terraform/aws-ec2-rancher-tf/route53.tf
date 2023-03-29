resource "aws_route53_zone" "aws_rke2_zone" {
  name = var.domain
  comment = "AWS RKE2 Route53 Hosted Zone"
  force_destroy = true
}

resource "aws_route53_record" "aws_rke2_record_rke2" {
  zone_id = aws_route53_zone.aws_rke2_zone.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = 300
  records = aws_eip.aws_eip_control.*.public_ip
}

resource "aws_route53_record" "aws_rke2_record_ingress" {
  zone_id = aws_route53_zone.aws_rke2_zone.zone_id
  name    = "*.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain]
}