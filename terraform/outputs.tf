# Output the static Elastic IP
output "instance_public_ip" {
  value = aws_eip.angular_eip.public_ip
}
