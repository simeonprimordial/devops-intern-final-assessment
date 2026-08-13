# DevOps Intern Final Assessment

![DevOps CI](https://github.com/simeonprimordial/devops-intern-final-assessment/actions/workflows/ci.yml/badge.svg?branch=main&event=push)

**Author:** Simeon Siaka  
**Date:** 13 August 2026

## Project Description

This repository contains my DevOps Intern Final Assessment. It demonstrates a small but realistic DevOps workflow using Git and GitHub, Linux shell scripting, Docker, GitHub Actions CI/CD, HashiCorp Nomad, Grafana Alloy, and Grafana Loki.

The project starts with a simple Python application and takes it through scripting, containerization, automated CI, workload scheduling, and centralized log collection.

## Assessment Goals

- Use Git and GitHub for source control.
- Create and execute a Linux shell script.
- Containerize a Python application with Docker.
- Run the application automatically in GitHub Actions on every push.
- Deploy the Docker container as a Nomad service job.
- Forward Docker logs to Grafana Loki and query them.
- Keep clear documentation and screenshot evidence for each stage.

## Project Progress

- [x] Step 1 — Git & GitHub files created
- [x] Step 2 — Linux system-information script created
- [x] Step 3 — Dockerfile created
- [x] Step 4 — GitHub Actions CI workflow created
- [x] Step 5 — Nomad job specification created
- [x] Step 6 — Loki/Alloy monitoring configuration created
- [ ] Local runtime verification and final screenshots
- [ ] Step 7 — Optional extra credit

## Repository Structure

```text
devops-intern-final-assessment/
├── .github/
│   └── workflows/
│       └── ci.yml
├── monitoring/
│   ├── config.alloy
│   ├── docker-compose.yml
│   ├── loki-config.yml
│   └── loki_setup.txt
├── nomad/
│   └── hello.nomad
├── screenshots/
│   └── README.md
├── scripts/
│   └── sysinfo.sh
├── .dockerignore
├── Dockerfile
├── README.md
└── hello.py
```

---

## 1. Git & GitHub Setup

Clone the repository:

```bash
git clone https://github.com/simeonprimordial/devops-intern-final-assessment.git
cd devops-intern-final-assessment
```

Run the Python application:

```bash
python hello.py
```

Expected output:

```text
Hello, DevOps!
```

The normal Git workflow used for changes is:

```bash
git status
git add .
git commit -m "describe the change"
git push origin main
```

---

## 2. Linux & Scripting Basics

The script is located at `scripts/sysinfo.sh`. It prints the current user, current date, and disk usage.

Ensure it is executable and run it:

```bash
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh
```

The script uses:

```bash
whoami
date
df -h
```

Take a screenshot of the successful output for the assessment evidence.

---

## 3. Docker Basics

Build the image from the repository root:

```bash
docker build -t devops-hello:1.0 .
```

Run the container:

```bash
docker run --rm devops-hello:1.0
```

Expected output:

```text
Hello, DevOps!
```

The Dockerfile copies `hello.py` into a Python container and runs `python hello.py` when the container starts.

---

## 4. CI/CD with GitHub Actions

The CI workflow is stored at:

```text
.github/workflows/ci.yml
```

The workflow runs on every push and pull request. It:

1. Checks out the repository.
2. Sets up Python.
3. Runs `python hello.py`.
4. Runs the Linux system-information script.

Push a commit to trigger the workflow:

```bash
git push origin main
```

Open the repository's **Actions** tab and capture a screenshot of a successful workflow run. The workflow badge at the top of this README also shows the CI status for `main`.

---

## 5. Job Deployment with Nomad

The Nomad job specification is located at:

```text
nomad/hello.nomad
```

It uses the Docker driver, runs as a `service` job, and requests minimal CPU and memory resources.

First build the local image if it does not already exist:

```bash
docker build -t devops-hello:1.0 .
```

Start a local Nomad development agent in a separate terminal:

```bash
nomad agent -dev
```

Validate the job:

```bash
nomad job validate nomad/hello.nomad
```

Run the job:

```bash
nomad job run nomad/hello.nomad
```

Check its status:

```bash
nomad job status devops-hello
```

Use the allocation ID shown by the status command to view application logs:

```bash
nomad alloc logs <ALLOC_ID>
```

The Nomad task keeps the assessment container running and writes `Hello, DevOps!` to its logs periodically.

Stop the job when finished:

```bash
nomad job stop -purge devops-hello
```

---

## 6. Monitoring with Grafana Loki

The monitoring setup uses **Grafana Alloy** to discover Docker containers, read their logs, and forward those logs to a local **Grafana Loki** instance.

Start the monitoring stack:

```bash
docker compose -f monitoring/docker-compose.yml up -d
```

Verify Loki:

```bash
curl http://localhost:3100/ready
```

Expected response:

```text
ready
```

Generate application logs:

```bash
docker run --rm --name devops-hello-monitor devops-hello:1.0 /bin/sh -c 'for i in 1 2 3 4 5; do python hello.py; sleep 2; done'
```

Query Loki:

```bash
curl -G -s "http://localhost:3100/loki/api/v1/query_range" --data-urlencode 'query={service_name="devops-hello-monitor"}'
```

The returned JSON should contain application log entries containing `Hello, DevOps!`.

Full setup and troubleshooting notes are available in [`monitoring/loki_setup.txt`](monitoring/loki_setup.txt).

Stop the monitoring stack:

```bash
docker compose -f monitoring/docker-compose.yml down
```

---

## Screenshot Evidence

The `screenshots/` directory contains a checklist for the evidence to capture before submission. Recommended evidence includes:

- GitHub repository and Python application output.
- Linux system-information script output.
- Docker build and container execution.
- Passing GitHub Actions workflow.
- Nomad job status/allocation logs.
- Loki query containing the application logs.

Do not include passwords, access tokens, or other secrets in screenshots.

## Final Deliverables

This repository includes the files required by the assessment:

- `README.md`
- `scripts/sysinfo.sh`
- `Dockerfile`
- `.github/workflows/ci.yml`
- `nomad/hello.nomad`
- `monitoring/loki_setup.txt`

Additional monitoring configuration files are included to make the Loki setup reproducible.
