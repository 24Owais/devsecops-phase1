# DevSecOps Phase 1: Secure Containerized Flask Service

A security-hardened Flask application containerized with Docker and verified through an automated DevSecOps CI/CD pipeline using GitHub Actions and Trivy.

## Features

* **Application Stack:** Python Flask application served via Gunicorn.
* **Multi-Stage Build:** Optimized Docker build process separating dependencies from the runtime environment.
* **Non-Root Runtime:** Runs under a dedicated `appuser` context to enforce least-privilege security principles.
* **Automated Security Scanning:** GitHub Actions pipeline running Aqua Security's Trivy scanner on every commit.

## Project Structure

```text
devsecops-phase1/
├── .github/
│   └── workflows/
│       └── container-scan.yml   # CI/CD security scan pipeline
├── app.py                       # Flask application
├── Dockerfile                   # Multi-stage non-root Docker build
├── requirements.txt             # Pinned dependencies
└── README.md                    # Documentation