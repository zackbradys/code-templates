<<<<<<< Updated upstream
data "aws_route53_zone" "aws_rke2_zone" {
  name = var.domain
}

resource "aws_route53_record" "aws_rke2_record_rke2" {
  zone_id = data.aws_route53_zone.aws_rke2_zone.zone_id
=======
resource "aws_route53_zone" "aws_rke2_zone" {
  name          = var.domain
  force_destroy = true
  comment       = "AWS RKE2 Route53 Hosted Zone"
  depends_on    = [aws_vpc.aws_rke2_vpc]
}

resource "aws_route53_record" "aws_rke2_record_rke2" {
  zone_id = aws_route53_zone.aws_rke2_zone.zone_id
>>>>>>> Stashed changes
  name    = ""
  type    = "A"
  alias {
    name                   = aws_elb.aws_rke2_lb.dns_name
    zone_id                = aws_elb.aws_rke2_lb.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_elb.aws_rke2_lb]
}

resource "aws_route53_record" "aws_rke2_record_ingress" {
<<<<<<< Updated upstream
  zone_id = data.aws_route53_zone.aws_rke2_zone.zone_id
=======
  zone_id = aws_route53_zone.aws_rke2_zone.zone_id
>>>>>>> Stashed changes
  name    = "*"
  type    = "A"
  alias {
    name                   = aws_elb.aws_rke2_ingress_lb.dns_name
    zone_id                = aws_elb.aws_rke2_ingress_lb.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_elb.aws_rke2_ingress_lb]
}