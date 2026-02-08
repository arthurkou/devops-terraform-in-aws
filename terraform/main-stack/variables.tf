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

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    name                     = "devops-na-nuvem-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "internet-gateway"
    nat_gateway_name         = "nat-gateway"
    public_route_table_name  = "public-route-table"
    private_route_table_name = "private-route-table"
    public_subnets = [{
      name                    = "public-us-east-1a"
      cidr_block              = "10.0.0.0/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "public-us-east-1b"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
      }
    ]
    private_subnets = [{
      name                    = "private-us-east-1a"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "private-us-east-1b"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
      }
    ]
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
      name                      = "devops-na-nuvem-queue-01"
      delay_seconds             = 90
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
    },
    {
      name                      = "devops-na-nuvem-queue-02"
      delay_seconds             = 90
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
    }
  ]
}

variable "eks_cluster" {

  type = object({
    name                                   = string
    role_name                              = string
    version                                = string
    enabled_cluster_log_types              = list(string)
    access_config_authentication_mode      = string
    node_group_name                        = string
    node_group_role_name                   = string
    node_group_capacity_type               = string
    node_group_instance_type               = list(string)
    node_group_scaling_config_desired_size = string
    node_group_scaling_config_max_size     = string
    node_group_scaling_config_min_size     = string
  })

  default = {
    name                                   = "devops-na-nuvem-eks-cluster"
    role_name                              = "DevOpsNaNuvemEKSClusterRole"
    version                                = "1.31"
    enabled_cluster_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    access_config_authentication_mode      = "API_AND_CONFIG_MAP"
    node_group_role_name                   = "DevOpsNaNuvemEKSNodeGroupRole"
    node_group_name                        = "devops-na-nuvem-eks-node-group"
    node_group_capacity_type               = "ON_DEMAND"
    node_group_instance_type               = ["t3.small"]
    node_group_scaling_config_desired_size = "2"
    node_group_scaling_config_max_size     = "3"
    node_group_scaling_config_min_size     = "2"
  }
}

variable "ecr_repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
    force_delete         = bool
  }))
  default = [
    {
      name                 = "minicursodevopsaws/production/frontend"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
    },
    {
      name                 = "minicursodevopsaws/production/backend"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
    }
  ]
}
