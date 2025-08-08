variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_name" {
  type        = string
  default     = "ai-game-studio"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "node_instance" {
  type        = string
  default     = "m6i.xlarge"
}

variable "gpu_instance" {
  type        = string
  default     = "g5.2xlarge"
}

variable "enable_spot_gpu" {
  type        = bool
  default     = true
}

variable "ecr_repo_prefix" {
  type        = string
  default     = "ai-game-studio"
}
