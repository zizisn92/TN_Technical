output "public_subnet_id1" {
  value = element(aws_subnet.public_subnet.*.id, 0)
}

output "public_subnet_id2" {
  value = element(aws_subnet.public_subnet.*.id, 1)
}

output "public_subnet_id3" {
  value = element(aws_subnet.public_subnet.*.id, 2)
}

output "private_subnet_id1" {
  value = element(aws_subnet.private_subnet.*.id, 0)
}

output "private_subnet_id2" {
  value = element(aws_subnet.private_subnet.*.id, 1)
}

output "private_subnet_id3" {
  value = element(aws_subnet.private_subnet.*.id, 2)
}

output "security_group_id" {
  value = aws_security_group.allow_http.id
}