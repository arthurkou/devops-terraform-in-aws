variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    project     = "devops-na-nuvem"
  }
}

variable "assume_role" {
  type = object({
    region   = string
    role_arn = string
  })

  default = {
    region   = "us-east-1"
    role_arn = "arn:aws:iam::781756701098:role/devops-na-nuvem-073a194f-dca3-4fa2-ad9d-8106a8a4a2a5"
  }
}

variable "remote_backend" {
  type = object({
    bucket_name                              = string
    dynamodb_table_name                      = string
    dynamodb_table_billing_mode              = string
    dynamodb_table_hash_key_attribute_name   = string
    dynamodb_table_hash_key_attribute_type   = string
  })

  default = {
    bucket_name                              = "devops-na-nuvem-remote-backend-bucket"
    dynamodb_table_name                      = "devops-na-nuvem-remote-backend-table"
    dynamodb_table_billing_mode              = "PAY_PER_REQUEST"
    dynamodb_table_hash_key_attribute_name   = "LockID"
    dynamodb_table_hash_key_attribute_type   = "S"
  }
}