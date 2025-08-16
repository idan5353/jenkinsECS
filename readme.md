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

<img width="1918" height="798" alt="צילום מסך 2025-08-16 233514" src="https://github.com/user-attachments/assets/7e5ef984-d140-4b24-b235-772e6cb3ba3d" />
<img width="1920" height="863" alt="צילום מסך 2025-08-16 233614" src="https://github.com/user-attachments/assets/27c93d65-dc54-41ba-8300-034457f85fb3" />
<img width="1920" height="831" alt="צילום מסך 2025-08-16 233703" src="https://github.com/user-attachments/assets/d8465029-30cc-4886-90cb-21ed8787202a" />
<img width="1917" height="999" alt="צילום מסך 2025-08-16 233421" src="https://github.com/user-attachments/assets/724692db-41d1-4e63-812a-b666a20f2361" />
<img width="1920" height="914" alt="צילום מסך 2025-08-16 233731" src="https://github.com/user-attachments/assets/f98c5f36-d088-4a69-bf9e-cbdd3057822d" />
<img width="1918" height="913" alt="צילום מסך 2025-08-16 233833" src="https://github.com/user-attachments/assets/307044c3-c789-4953-92f8-c715d17b90e9" />
