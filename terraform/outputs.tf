output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "app_dev_public_ip" {
  value = aws_instance.app_dev.public_ip
}
