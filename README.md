# AI Game Studio — Monorepo (Bootstrap)

This repo scaffolds the cloud-first build of the AI Game Studio platform. It is designed so a low-power laptop can act as a control console while all heavy compute runs in the cloud.

## High-Level Stack
- **Infra**: AWS EKS (Kubernetes), GPU node group (spot preferred), IAM OIDC, ECR.
- **Core services**: Vault, RabbitMQ, Supabase (managed), Neo4j, Qdrant, MinIO, ClickHouse+immudb.
- **GitOps**: Argo CD (app-of-apps).
- **CI/CD**: GitHub Actions -> build/push images -> Argo CD sync.
- **Observability**: Prometheus, Grafana, Loki, Jaeger.
- **Services**: Minimal stubs for Trend-Scout, Idea-Forge, Prototype Orchestrator.

> This is a **bootstrap** repo: it gets you to a working cluster with placeholders. You will iteratively replace stubs with full implementations from your detailed spec.

## Quick Start

### 0) Prereqs (local console only)
- `awscli`, `kubectl`, `helm`, `terraform`, `git`
- A GitHub repo (we recommend private), and AWS account with admin during bootstrap

### 1) Fill Terraform variables
Edit `infra/terraform/terraform.tfvars`:
```hcl
aws_region        = "us-west-2"
cluster_name      = "ai-game-studio"
node_instance     = "m6i.xlarge"
gpu_instance      = "g5.2xlarge"
enable_spot_gpu   = true
```
Optional: adjust CIDR ranges in `variables.tf` if needed.

### 2) Provision base infra
```bash
cd infra/terraform
terraform init
terraform apply
```
Outputs will include kubeconfig export, ECR URL, and ARNs.

### 3) Install Argo CD & bootstrap apps
```bash
# set kube context to the new cluster
aws eks update-kubeconfig --region <region> --name <cluster_name>
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd -n argocd -f infra/helm/argocd-values.yaml

# GitOps app-of-apps
kubectl apply -n argocd -f k8s/bootstrap/app-of-apps.yaml
```

### 4) Configure GitHub secrets
In your GitHub repo settings -> **Secrets and variables** -> Actions:
- `AWS_REGION`, `AWS_ACCOUNT_ID`
- `ECR_REGISTRY` (e.g., `ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com`)
- `ECR_REPOSITORY_PREFIX` (e.g., `ai-game-studio`)
- `KUBECONFIG_BASE64` (optional: if using runner-side kubectl)
- `ARGOCD_SERVER`, `ARGOCD_AUTH_TOKEN` (optional for forced sync)

### 5) First deploy
Push to `main`. GitHub Actions will build and push the images and Argo CD will sync workloads into cluster. Check progress:
```bash
kubectl get pods -A
kubectl -n observability port-forward svc/grafana 3000:80
```

## Structure
```
infra/
  terraform/        # EKS, VPC, NodeGroups (CPU+GPU), ECR, OIDC
  helm/             # Argo CD values, Prometheus stack values
k8s/
  bootstrap/        # Namespaces, app-of-apps, Argo CD Applications
charts/
  umbrella/         # Helm umbrella for core services
  trend-scout/
  idea-forge/
  proto-orchestrator/
services/
  trend-scout/      # Python stub + Dockerfile + Helm chart
  idea-forge/       # Python FastAPI stub
  proto-orchestrator/ # Python FastAPI worker
config/
  moon_pools.yml
  personas.yml
migrations/
  0001_init.sql
.github/workflows/
  ci.yml
```

## Next Steps
- Replace service stubs with full implementations (see TODOs in each service).
- Add remaining services and charts following the same pattern (copy an existing chart and modify).
