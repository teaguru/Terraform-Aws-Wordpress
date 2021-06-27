output "web_access" {
  value = "http://${aws_lb.app.dns_name}"
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.mykey.private_key_pem
  filename = "private_key.pem"
  file_permission = "0600"
}

output "ssh_access" {
  value = "ssh ec2-user@${aws_instance.ec2[0].public_ip} -i ${local_file.private_key.filename}"
}

resource "local_file" "credentials" {
  sensitive_content = <<_EOF
ssh ec2-user@${aws_instance.ec2[0].public_ip} -i ${local_file.private_key.filename}
http://${aws_lb.app.dns_name}
mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${aws_db_instance.mysql.username} -p${random_password.db_pass.result}
_EOF
  filename = "credentials"
}

