variable "ami_name" {
  description = "Name of the AMI to be created"
  type        = string

  validation {
    condition     = length(var.ami_name) > 3
    error_message = "Ami_name must be more than 3 characters."
  }
}

variable "environment" {
  description = "Deployment environment name used for AMI and builder tags"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, prod."
  }
}

variable "instance_type" {
  description = "Instance type to use for building the AMI"
  type        = string

  validation {
    condition     = can(regex("^[a-z][0-9][a-z]?\\.", var.instance_type))
    error_message = "Instance_type must look like a valid EC2 instance type, for example t2.micro."
  }
}

variable "region" {
  description = "AWS region to use"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "Region must be a valid AWS region name, for example ap-south-1."
  }
}

variable "ssh_username" {
  description = "SSH username for the instance"
  type        = string

  validation {
    condition     = length(var.ssh_username) > 0
    error_message = "Ssh_username cannot be empty."
  }
}
