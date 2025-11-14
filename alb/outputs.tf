output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_name" {
  value = aws_alb.alb.name
}
output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_alb.alb.zone_id
}
output "alb_arn" {
  value = aws_alb.alb.arn
}
output "alb_id" {
  value = aws_alb.alb.id
}
// output "aws_alb_target_group_http" {
//   value = aws_alb_target_group.http.id
// }
output "aws_alb_target_group_https" {
  value = aws_alb_target_group.https.id
}
