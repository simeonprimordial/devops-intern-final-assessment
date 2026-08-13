#!/usr/bin/env bash

set -Eeuo pipefail

APP_IMAGE="devops-hello:1.0"
MONITOR_CONTAINER="devops-hello-monitor"
COMPOSE_FILE="monitoring/docker-compose.yml"

cleanup() {
  docker rm -f "$MONITOR_CONTAINER" >/dev/null 2>&1 || true
  docker compose -f "$COMPOSE_FILE" down -v >/dev/null 2>&1 || true
}

trap cleanup EXIT

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: required command '$1' was not found." >&2
    exit 1
  fi
}

require docker
require curl

if command -v python3 >/dev/null 2>&1; then
  PYTHON=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON=python
else
  echo "ERROR: Python was not found." >&2
  exit 1
fi

echo "========================================"
echo " DevOps Assessment Local Verification"
echo "========================================"

echo
echo "[1/7] Running Python application"
"$PYTHON" hello.py | tee /tmp/devops-hello-python.txt
grep -F "Hello, DevOps!" /tmp/devops-hello-python.txt

echo
echo "[2/7] Running Linux system information script"
bash -n scripts/sysinfo.sh
bash scripts/sysinfo.sh

echo
echo "[3/7] Building Docker image"
docker build -t "$APP_IMAGE" .

echo
echo "[4/7] Running Docker container"
docker run --rm "$APP_IMAGE" | tee /tmp/devops-hello-docker.txt
grep -F "Hello, DevOps!" /tmp/devops-hello-docker.txt

echo
echo "[5/7] Validating Docker Compose and Nomad configuration"
docker compose -f "$COMPOSE_FILE" config --quiet

if command -v nomad >/dev/null 2>&1; then
  nomad fmt -check nomad/hello.nomad
  nomad job validate nomad/hello.nomad
else
  echo "Nomad CLI not found locally; validating the job with the official Nomad container image instead."
  docker run --rm \
    -v "$PWD/nomad:/workspace" \
    -w /workspace \
    hashicorp/nomad:latest \
    fmt -check hello.nomad

  docker run --rm \
    -v "$PWD/nomad:/workspace" \
    -w /workspace \
    hashicorp/nomad:latest \
    job validate hello.nomad
fi

echo
echo "[6/7] Starting Grafana Loki and Alloy"
docker compose -f "$COMPOSE_FILE" up -d

for attempt in $(seq 1 20); do
  if curl --fail --silent http://localhost:3100/ready >/dev/null 2>&1; then
    echo "Loki is ready."
    break
  fi

  if [ "$attempt" -eq 20 ]; then
    echo "ERROR: Loki did not become ready in time." >&2
    docker logs loki || true
    exit 1
  fi

  sleep 2
done

echo
echo "[7/7] Generating logs and verifying Loki ingestion"
docker run -d \
  --name "$MONITOR_CONTAINER" \
  "$APP_IMAGE" \
  /bin/sh -c 'while true; do python hello.py; sleep 2; done' >/dev/null

sleep 10

docker logs "$MONITOR_CONTAINER"

curl -G --fail --silent --show-error \
  "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={service_name="devops-hello-monitor"}' \
  --data-urlencode 'limit=20' \
  | tee /tmp/devops-loki-query.json

grep -F "Hello, DevOps!" /tmp/devops-loki-query.json >/dev/null

echo
echo "========================================"
echo " All automated checks passed"
echo "========================================"
echo "Nomad job deployment is intentionally kept as a separate manual evidence step so you can capture job status and allocation logs from your local Nomad dev agent."
