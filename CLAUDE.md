# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A small, flat Terraform root module (a learning project) that manages an AWS ECR repository, `home-inventory`, in `eu-west-2`. There is no application code, test suite, CI, or README. It is a sibling of `../aws-vpc` and `../log-cleaner`, which are separate root modules with their own state.

## Commands

Run from this directory. The AWS provider uses the named profile `admin-sso` (the `running_profile` variable), which is an SSO profile, so log in first:

```sh
aws sso login --profile admin-sso
terraform init
terraform fmt -check     # or `terraform fmt` to fix
terraform validate
terraform plan
terraform apply
```

Override the profile with `-var running_profile=<name>`.

State is local (no backend is configured) and `.terraform/` is not under version control (this directory is not a git repo), so `terraform.tfstate` is the only record of what has been applied.

## Layout

- `terraform.tf`: required versions (Terraform `>= 1.3`, `hashicorp/aws ~> 6.0`) and the `aws` provider block.
- `ecr.tf`: all resources. There is an account-level ECR setting (`BASIC_SCAN_TYPE_VERSION = AWS_NATIVE`), the `home-inventory` repository (mutable tags, scan on push), and a lifecycle policy on that repository.
- `variables.tf`: all variables.

## Gotchas

- **Region is hardcoded.** The provider in `terraform.tf` sets `region = "eu-west-2"` and ignores the `aws_region` variable. Change the provider block if the region needs to change.
- **Most variables are unused.** Only `running_profile` and `ecr_expiry_days` are referenced. `vpc_cidr`, `azs`, `public_subnet_cidrs`, `private_subnet_cidrs`, `ec2_instance_type`, `project_name`, `creator_tag` and `aws_region` look copied from the `../aws-vpc` module. Don't assume they have any effect here.
- **The lifecycle policy is a JSON heredoc.** In `ecr.tf` it is a `<<EOF` heredoc, so variables must be interpolated as `${var.ecr_expiry_days}`. A bare `var.` reference is not evaluated and makes the JSON invalid.
- `aws_ecr_account_setting` is account-wide, not repository-scoped. Applying it changes the scan type for every repository in the account.
