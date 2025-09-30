# ☁️ Weather Portal - Full-Stack DevOps Project

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## 📋 Project Overview

Enterprise-grade full-stack weather application demonstrating production-ready DevOps practices, cloud architecture design, and infrastructure automation. Built to showcase end-to-end platform engineering capabilities from development to deployment

##  Features

- **Real-Time Weather Data**: Fetches current weather information using OpenWeatherMap API
- **Modern Frontend**: Responsive React-based user interface
- **Robust Backend**: Node.js/Flask backend handling API requests and data processing
- **Containerized Architecture**: Fully Dockerized frontend and backend services
- **Cloud Infrastructure**: Deployed on AWS EC2 instances with proper security configurations
- **Automated CI/CD**: Jenkins pipeline for continuous integration and deployment
- **Infrastructure as Code**: Terraform scripts for reproducible EC2 provisioning
- **Secure Credentials Management**: API keys stored securely in Jenkins credentials store

##  Architecture

The application follows a microservices architecture with separate containers for frontend and backend, deployed across multiple EC2 instances with a dedicated Jenkins server for CI/CD automation.


```
                           ┌─────────────────┐
                           │   GitHub Repo   │
                           └────────┬────────┘
                                    │
                           ┌────────▼────────┐
                           │  Jenkins CI/CD  │
                           │   (EC2 Master)  │
                           └────────┬────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
            ┌───────▼──────┐ ┌─────▼──────┐ ┌─────▼──────┐
            │   Frontend   │ │  Backend   │ │  Future:   │
            │   (React)    │ │  (Node.js) │ │  Database  │
            │   EC2 + ELB  │ │  EC2 + ELB │ │   RDS      │
            └──────────────┘ └────────────┘ └────────────┘
                    │               │
            ┌───────▼───────────────▼────────┐
            │    AWS Security Groups         │
            │  + IAM Roles + CloudWatch      │
            └────────────────────────────────┘
```
##  Installation & Setup

### Prerequisites

- Docker and Docker Compose installed
- Node.js (for local development)
- AWS account with EC2 access
- OpenWeatherMap API key
- Git

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/multi-cloud-weather.git
   cd multi-cloud-weather
   ```

2. **Set up environment variables**
   
   Create a `.env` file in the backend directory:
   ```bash
   OPENWEATHER_API_KEY=your_api_key_here
   PORT=5000
   ```

3. **Build and run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

4. **Access the application**
   - Frontend: `http://localhost:3000`
   - Backend: `http://localhost:5000`

### Manual Docker Build

**Frontend:**
```bash
cd website
docker build -t weather-frontend .
docker run -p 3000:3000 weather-frontend
```

**Backend:**
```bash
cd backend
docker build -t weather-backend .
docker run -p 5000:5000 -e OPENWEATHER_API_KEY=your_key weather-backend
```

## ☁️ AWS Deployment

### Infrastructure Provisioning with Terraform

1. **Navigate to Terraform directory**
   ```bash
   cd terraform/aws
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the execution plan**
   ```bash
   terraform plan
   ```

4. **Apply infrastructure changes**
   ```bash
   terraform apply
   ```

### EC2 Instance Configuration

The project uses three EC2 instances:
- **Frontend Server**: Hosts the React application container
- **Backend Server**: Hosts the Node.js/Flask API container
- **Jenkins Server**: Runs CI/CD pipeline with Docker Pipeline plugin

Security groups are configured to allow:
- HTTP (80) and HTTPS (443) traffic
- Jenkins access on port 8080
- SSH access for administration

## 🔄 CI/CD Pipeline

### Jenkins Setup

1. **Install Jenkins on EC2**
   ```bash
   # SSH into Jenkins EC2 instance
   sudo yum update -y
   sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
   sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
   sudo yum install jenkins java-11-openjdk-devel -y
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ```

2. **Install Required Plugins**
   - Docker Pipeline
   - Git Plugin

3. **Configure Credentials**
   - Navigate to Jenkins → Manage Jenkins → Credentials
   - Add OpenWeatherMap API key as secret text
   - Add AWS credentials if using automated deployments

### Pipeline Workflow

The Jenkins pipeline (`Jenkinsfile`) automates the following stages:

```groovy
1. Checkout Code from GitHub
2. Build Docker Images (Frontend + Backend)
3. Run Tests
4. Push Images to Registry (optional)
5. Deploy Containers to EC2 Instances
6. Health Check
```

### Triggering the Pipeline

The pipeline can be triggered:
- Manually from Jenkins dashboard
- Automatically via GitHub webhooks on push/merge
- Scheduled builds using cron syntax

## 🔐 Environment Variables & API Key Setup

### Backend Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `OPENWEATHER_API_KEY` | API key from OpenWeatherMap | `abc123def456` |
| `PORT` | Backend server port | `5000` |
| `NODE_ENV` | Environment mode | `production` |

### Jenkins Credentials Configuration

1. Create OpenWeatherMap account at [openweathermap.org](https://openweathermap.org/api)
2. Generate API key from account dashboard
3. In Jenkins: Manage Jenkins → Credentials → Add Credentials
4. Select "Secret text" and paste API key
5. Set ID as `OPENWEATHER_API_KEY`

## 📁 Folder Structure

```
multi-cloud-weather/
├── backend/                    # Backend application
│   ├── src/                   # Source code
│   ├── Dockerfile             # Backend container configuration
│   ├── package.json           # Node.js dependencies
│   └── requirements.txt       # Python dependencies (if Flask)
├── website/                    # Frontend application
│   ├── public/                # Static assets
│   ├── src/                   # React components
│   ├── Dockerfile             # Frontend container configuration
│   └── package.json           # npm dependencies
├── terraform/
│   └── aws/                   # AWS infrastructure code
│       ├── main.tf            # EC2 instance definitions
│       ├── variables.tf       # Input variables
│       └── outputs.tf         # Output values
├── docker-compose.yml          # Local development orchestration
├── Jenkinsfile                 # CI/CD pipeline definition
├── .gitignore                  # Git ignore rules
└── README.md                   # Project documentation
```

##  Future Enhancements

### Multi-Cloud Strategy
- **Azure Integration**: Deploy redundant infrastructure on Azure for high availability
- **DNS Failover**: Implement Route 53 DNS failover between AWS and Azure regions
- **Cross-Cloud Load Balancing**: Distribute traffic intelligently across cloud providers

### Infrastructure Improvements
- **Elastic IPs**: Assign static IPs to EC2 instances for consistent access
- **Auto-Scaling**: Configure EC2 Auto Scaling Groups based on traffic patterns
- **Container Orchestration**: Migrate to Kubernetes (EKS/AKS) for better scalability
- **Load Balancer**: Add Application Load Balancer for high availability

### DevOps Enhancements
- **GitOps Workflow**: Implement ArgoCD or Flux for declarative deployments
- **Monitoring & Logging**: Integrate Prometheus, Grafana, and ELK stack
- **Automated Testing**: Expand test coverage with integration and E2E tests
- **Secrets Management**: Migrate to AWS Secrets Manager or HashiCorp Vault
- **Blue-Green Deployments**: Implement zero-downtime deployment strategy

### Application Features
- **Weather Forecasts**: Add 5-day and 7-day forecast capabilities
- **Location Services**: Implement geolocation-based weather detection
- **Historical Data**: Display weather trends and historical comparisons
- **User Preferences**: Save favorite locations and custom settings

## 🛠️ Technologies Used

- **Frontend**: React, JavaScript, HTML5, CSS3
- **Backend**: Node.js / Flask, Express
- **Containerization**: Docker, Docker Compose
- **CI/CD**: Jenkins, Jenkinsfile (Pipeline as Code)
- **Cloud**: AWS EC2, Security Groups
- **IaC**: Terraform
- **Version Control**: Git, GitHub
- **API**: OpenWeatherMap REST API

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⭐ Show your support

Give a ⭐️ if this project helped you learn DevOps concepts!

---

**Note**: Remember to replace placeholder values (API keys, GitHub URLs, contact information) with your actual details before sharing this README.
