packer {
  required_version = ">= 1.8.0"

  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_description = "Ubuntu 22.04 AMI with nginx for ${var.environment}"
  ami_name        = var.ami_name
  instance_type   = var.instance_type
  region          = var.region

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = var.ssh_username

  tags = {
    Name        = var.ami_name
    Environment = var.environment
    ManagedBy   = "packer"
    Source      = "ubuntu-jammy-22.04"
  }

  run_tags = {
    Name        = "packer-builder-${var.environment}"
    Environment = var.environment
    ManagedBy   = "packer"
  }
}

build {
  name    = "ubuntu-nginx-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"

    inline = [
      "set -eux",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update -y",
      "apt-get install -y nginx",
      "systemctl enable nginx",
      "nginx -v",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*"
    ]
  }
}
