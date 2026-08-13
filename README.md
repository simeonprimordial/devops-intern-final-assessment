# DevOps Intern Final Assessment

**Author:** Simeon Siaka  
**Date:** 13 August 2026

## Project Description

This repository contains my DevOps Intern Final Assessment. The project demonstrates a small but realistic DevOps workflow using Git and GitHub, Linux shell scripting, Docker, GitHub Actions CI/CD, HashiCorp Nomad, and Grafana Loki.

The assessment is built step by step so that each stage can be tested, documented, and supported with screenshots before final submission.

## Assessment Goals

- Use Git and GitHub for source control.
- Create and run a Linux system-information shell script.
- Containerize a Python application with Docker.
- Build a GitHub Actions CI pipeline.
- Deploy the application as a Nomad job.
- Collect and inspect logs with Grafana Loki.
- Document commands, configuration, screenshots, and lessons learned.

## Project Progress

- [x] Step 1 — Git & GitHub setup
- [ ] Step 2 — Linux & scripting basics
- [ ] Step 3 — Docker basics
- [ ] Step 4 — CI/CD with GitHub Actions
- [ ] Step 5 — Job deployment with Nomad
- [ ] Step 6 — Monitoring with Grafana Loki
- [ ] Step 7 — Optional extra credit

## Step 1 — Git & GitHub Setup

The project begins with a public GitHub repository and a simple Python application.

### Run the application

```bash
python hello.py
```

Expected output:

```text
Hello, DevOps!
```

### Git workflow

```bash
git clone https://github.com/simeonprimordial/devops-intern-final-assessment.git
cd devops-intern-final-assessment
python hello.py
```

## Planned Repository Structure

```text
devops-intern-final-assessment/
├── .github/
│   └── workflows/
│       └── ci.yml
├── monitoring/
│   └── loki_setup.txt
├── nomad/
│   └── hello.nomad
├── screenshots/
├── scripts/
│   └── sysinfo.sh
├── Dockerfile
├── README.md
└── hello.py
```

More documentation will be added as each assessment step is completed and tested.
