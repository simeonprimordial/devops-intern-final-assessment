job "devops-hello" {
  datacenters = ["dc1"]
  type        = "service"

  group "hello-group" {
    count = 1

    task "hello" {
      driver = "docker"

      config {
        image      = "devops-hello:1.0"
        force_pull = false
        command    = "/bin/sh"
        args       = ["-c", "while true; do python hello.py; sleep 30; done"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
