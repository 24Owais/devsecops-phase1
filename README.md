# DevSecOps Pipeline: Container & IaC Security Automation

A robust DevSecOps pipeline automating both container security and Infrastructure as Code (IaC) compliance using GitHub Actions, Trivy, and Checkov.

## Architecture & Security Gates

1. **Phase 1: Container Hardening (Trivy)**
   - **App:** Flask + Gunicorn web service.
   - **Security:** Multi-stage build running under a non-root `appuser`.
   - **Scanner:** Trivy blocks builds containing `CRITICAL` or `HIGH` Python/OS vulnerabilities.

2. **Phase 2: IaC Compliance (Checkov)**
   - **IaC:** Hardened AWS S3 bucket configured via Terraform.
   - **Security:** Enforced Server-Side Encryption (AES256), Public Access Block, Bucket Versioning, and Lifecycle Rules.
   - **Scanner:** Checkov statically audits Terraform files to block misconfigured cloud resources before deployment.

## Pipeline Workflows

- `.github/workflows/container-scan.yml` — Builds Docker image and executes Trivy scanner.
- `.github/workflows/iac-scan.yml` — Scans `terraform/` directory using Checkov.