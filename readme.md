# Jenkins + ECS + Monitoring on AWS

This project demonstrates a **full DevOps stack on AWS** using Terraform, including:

- Jenkins server for CI/CD
- Amazon ECS for containerized applications
- Application Load Balancer (ALB)
- Auto-scaling ECS tasks
- Prometheus + Grafana for monitoring

---



---

## Terraform Modules

### VPC
- 2 Public subnets for Jenkins, ALB, and monitoring
- 2 Private subnets for backend ECS services

### Security Groups
- `jenkins-sg`: Allow SSH (22) & Jenkins UI (8080)
- `ecs-sg`: Allow ALB to reach ECS tasks on app port (3000)
- `monitoring-sg`: Allow Prometheus (9090) & Grafana (3000)

### IAM
- `jenkins-role` for EC2 to access ECS and ECR
- `ecs-task-execution-role` for ECS tasks to pull images & send logs to CloudWatch

### ECS
- Task Definitions for:
  - My App (port 3000)
  - Prometheus (port 9090)
  - Grafana (port 3000)
- ECS Services running on **Fargate** with `awsvpc` network mode
- Application Load Balancer in front of My App service
- Auto Scaling based on CPU and memory metrics

### Monitoring
- Prometheus collects metrics from ECS tasks
- Grafana visualizes metrics from Prometheus
- Logs are sent to CloudWatch for both Prometheus and Grafana

---

## Terraform Outputs

After applying Terraform:

- **Jenkins URL:** `http://<Jenkins_Public_IP>:8080`
- **My App URL:** `http://<ALB_DNS_Name>:80`
- **Prometheus URL:** `http://<Prometheus_Public_IP>:9090`
- **Grafana URL:** `http://<Grafana_Public_IP>:3000`

---

## How to Deploy

1. Clone the repository:
```bash
git clone <your-repo-url>
cd <repo-directory>

