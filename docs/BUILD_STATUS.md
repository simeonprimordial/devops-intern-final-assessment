# Build Status

This repository has completed the required implementation for the DevOps Intern Final Assessment.

## Automated validation

The GitHub Actions workflow validates the following on every push and pull request:

- Python syntax and execution of `hello.py`
- Linux shell syntax and execution of `scripts/sysinfo.sh`
- Syntax of the local verification helper
- Docker image build
- Docker container execution and expected output
- Docker Compose configuration for monitoring
- Nomad job formatting and job validation
- Grafana Loki and Grafana Alloy startup
- Loki readiness
- Docker log generation
- End-to-end verification that `Hello, DevOps!` reaches Loki

## Remaining manual evidence

The only remaining submission work is local evidence capture:

1. GitHub/Python execution screenshot
2. Linux `sysinfo.sh` screenshot
3. Docker build/run screenshot
4. Passing GitHub Actions screenshot
5. Nomad development-agent job status/allocation logs screenshot
6. Loki query screenshot

The helper script `scripts/verify_local.sh` automates most local checks. Run it from a Linux shell or WSL with:

```bash
bash scripts/verify_local.sh
```

Nomad deployment remains a separate manual step so the final submission can show a real Nomad job status and allocation log output.
