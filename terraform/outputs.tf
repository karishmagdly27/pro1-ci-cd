output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "nexus_public_ip" {
  value = aws_instance.nexus.public_ip
}

output "app_dev_public_ip" {
  value = aws_instance.app["dev"].public_ip
}

output "app_staging_public_ip" {
  value = aws_instance.app["staging"].public_ip
}

output "app_prod_public_ip" {
  value = aws_instance.app["prod"].public_ip
}