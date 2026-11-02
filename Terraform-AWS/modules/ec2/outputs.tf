output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.private_ip
}

output "ami_id" {
  description = "AMI ID used by the EC2 instance"
  value       = aws_instance.ec2_instance.ami
}