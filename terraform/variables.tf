variable "aws_region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "ci_cd_key" 
}

# Remove public_key_path since we already have AWS key
# variable "public_key_path" {
#   default = "C:\\Users\\kruta\\.ssh\\ci_cd_key.pub"
# }
