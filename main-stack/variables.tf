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
    region = "us-east-1"
    role_arn = "arn:aws:iam::781756701098:role/devops-na-nuvem-073a194f-dca3-4fa2-ad9d-8106a8a4a2a5"
  }
}

variable "queues" {
  type = list(object({
    name                      = string
    delay_seconds             = number 
    max_message_size          = number 
    message_retention_seconds = number 
    receive_wait_time_seconds = number
  }))

  default = [ 
    {
        name                          = "devops-na-nuvem-queue-01"
        delay_seconds                 = 90
        max_message_size              = 2048
        message_retention_seconds     = 86400
        receive_wait_time_seconds     = 10
    },
    {
        name                          = "devops-na-nuvem-queue-02"
        delay_seconds                 = 90
        max_message_size              = 2048
        message_retention_seconds     = 86400
        receive_wait_time_seconds     = 10
    }
  ]       
}