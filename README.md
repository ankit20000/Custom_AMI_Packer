# Custom AMI Packer

This repository contains Packer templates for building AWS EBS-backed Ubuntu AMIs. The maintained template lives in `ami-Creation` and creates an Ubuntu 22.04 AMI with nginx installed and enabled.

## What It Builds

- Base image: latest official Ubuntu Jammy 22.04 amd64 server AMI
- AWS builder: `amazon-ebs`
- Region: configured per environment variable file
- Provisioning: installs nginx, enables the service, verifies the nginx binary, and cleans apt package metadata
- Tags: applies environment and ownership tags to both the temporary builder instance and the final AMI

## Repository Layout

```text
ami-Creation/
  aws-ubuntu.pkr.hcl          # Main Packer template
  variables.pkr.hcl           # Variable declarations and validation
  variables.pkrvars.hcl       # Dev values
  qavariables.pkrvars.hcl     # QA values
.github/workflows/packer.yml  # CI validation workflow
Lab*.md                       # Learning notes for Packer labs
```

## Prerequisites

- Packer 1.8 or newer
- AWS credentials with permissions to create EC2 instances, EBS snapshots, and AMIs
- An AWS account where temporary build resources and AMI snapshots can be created

Configure credentials using your normal AWS method, for example:

```bash
aws configure
```

## Validate

Run validation before building:

```bash
cd ami-Creation
packer init .
packer fmt -check .
packer validate -var-file=variables.pkrvars.hcl .
packer validate -var-file=qavariables.pkrvars.hcl .
```

## Build

Build the dev AMI:

```bash
cd ami-Creation
packer build -var-file=variables.pkrvars.hcl .
```

Build the QA AMI:

```bash
cd ami-Creation
packer build -var-file=qavariables.pkrvars.hcl .
```

Packer will create a temporary EC2 instance during the build, install nginx, create an AMI from the instance, and then clean up the temporary instance.

## CI

The GitHub Actions workflow validates formatting and both environment variable files on pull requests. It does not run `packer build`, because creating AMIs from CI can produce AWS costs and should be triggered intentionally.
