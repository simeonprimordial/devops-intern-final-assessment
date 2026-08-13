# Local Run Guide

Use a Linux shell or WSL for the cleanest assessment experience.

## Automated checks

From the repository root:

```bash
bash scripts/verify_local.sh
```

This verifies the Python app, Linux script, Docker image, Docker container, Nomad job syntax, Docker Compose configuration, Grafana Loki, Grafana Alloy, and end-to-end log ingestion.

## Nomad deployment evidence

Keep this as a separate manual step because the assessment specifically asks you to run the job with Nomad and show the deployment output.

Terminal 1:

```bash
nomad agent -dev
```

Terminal 2:

```bash
docker build -t devops-hello:1.0 .
nomad job validate nomad/hello.nomad
nomad job run nomad/hello.nomad
nomad job status devops-hello
```

Copy the allocation ID from the status output and run:

```bash
nomad alloc logs <ALLOC_ID>
```

Capture a screenshot showing the job is running and the logs contain:

```text
Hello, DevOps!
```

When finished:

```bash
nomad job stop -purge devops-hello
```
