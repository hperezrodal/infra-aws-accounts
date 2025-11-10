# INFRA AWS ACCOUNTS

Terraform-driven AWS landing zone for non-production environments with opinionated automation, guardrails, and supporting tooling.

![GitHub Release](https://img.shields.io/github/v/release/hperezrodal/infra-aws-accounts?style=flat-square)
[![GitHub Issues](https://img.shields.io/github/issues/hperezrodal/infra-aws-accounts?style=flat-square)](https://github.com/hperezrodal/infra-aws-accounts/issues)
[![GitHub Stars](https://img.shields.io/github/stars/hperezrodal/infra-aws-accounts?style=flat-square)](https://github.com/hperezrodal/infra-aws-accounts/stargazers)
![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA?style=flat-square)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=flat-square)
[![License](https://img.shields.io/github/license/hperezrodal/infra-aws-accounts?style=flat-square)](LICENSE)

## 🚀 Overview

- Multi-account AWS architecture focused on **develop**, **staging**, and **UAT** environments
- Reusable Terraform modules with opinionated defaults
- Automated networking, IAM guardrails, and foundational services
- Documentation-first approach with environment-specific runbooks
- Seamless integration with CI/CD pipelines and auditing tooling

## 📋 Prerequisites

### Required Tooling

- **Terraform** `>= 1.5.0`
- **AWS CLI** configured with appropriate credentials
- **jq** and **GNU make** (for helper scripts)
- Direct or federated access to non-production AWS accounts

### AWS Permissions

- Ability to assume administrative roles in target accounts
- Policy permissions to create IAM roles, VPC resources, and logging infrastructure

## 📦 Getting Started

### Clone & Bootstrap

```bash
git clone https://github.com/hperezrodal/infra-aws-accounts.git
cd infra-aws-accounts
chmod +x scripts/*.sh
./scripts/setup-aws.sh
```

### Configure Your Shell

```bash
source ~/.bashrc
```

### Initialize Terraform

```bash
terraform init
terraform workspace new dev
terraform workspace new stg
terraform workspace new uat
```

## 🧪 Working With Environments

```bash
# Develop environment
terraform workspace select dev
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"

# Staging environment
terraform workspace select stg
terraform plan -var-file="env/stg.tfvars"
terraform apply -var-file="env/stg.tfvars"

# UAT environment
terraform workspace select uat
terraform plan -var-file="env/uat.tfvars"
terraform apply -var-file="env/uat.tfvars"
```

All environment documentation lives under `docs/`. Each guide contains connection details for bastion hosts, operational playbooks, and escalation paths:

- [Develop Environment](docs/dev.md) _(coming soon)_
- [Staging Environment](docs/stg.md)
- [UAT Environment](docs/uat.md) _(coming soon)_

## 🛠️ Project Structure

```
infra-aws-accounts/
├── modules/               # Reusable Terraform modules
├── env/                   # Environment tfvars
├── docs/                  # Environment and ops documentation
├── scripts/               # Bootstrap & helper scripts
├── policies/              # IAM templates and SCPs
├── .github/workflows/     # CI/CD pipelines
└── CONTRIBUTING.md        # Contribution guidelines
```

## 🔐 Security & Compliance

- Enforced tagging and least-privilege IAM policies
- Centralized CloudTrail, Config, and GuardDuty configuration
- SCPs for boundary enforcement across non-production accounts
- Optional integrations with security scanning tools via GitHub Actions

## 📚 Documentation

- [Contribution Guidelines](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md) _(if present)_
- [License](LICENSE)

## 🤝 Contributing

Pull requests are welcome! Please review the contribution guidelines, run formatting checks, and validate Terraform plans before submitting.

---

Made with ❤️ by [hperezrodal](https://github.com/hperezrodal)
