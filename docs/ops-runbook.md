# Ops Runbook (Cloud-First)

## TL;DR
- You push to `main` -> CI builds/pushes images -> Argo CD syncs charts -> services roll out.
- Your i3 laptop is a thin client. Never run Docker locally for heavy tasks.

## First Deployment Checklist
1. `terraform apply` in `infra/terraform`.
2. `aws eks update-kubeconfig ...` to set cluster context.
3. Install Argo CD & apply `k8s/bootstrap/app-of-apps.yaml`.
4. Set GitHub Actions secrets for AWS/ECR (see README).
5. Push to `main` and watch Argo CD deploy apps.
6. `kubectl get pods -n idea-pipeline` until all are Running.

## URLs (when port-forwarded)
- RabbitMQ mgmt: `kubectl -n idea-pipeline port-forward svc/rabbitmq 15672:15672`
- Neo4j Browser: `kubectl -n idea-pipeline port-forward svc/neo4j 7474:7474`
- MinIO Console: `kubectl -n idea-pipeline port-forward svc/minio 9001:9001`
- Qdrant API: `kubectl -n idea-pipeline port-forward svc/qdrant 6333:6333`

## Common Issues
- **Images not found**: CI didn’t push or charts didn’t get patched with ECR URL.
- **CrashLoopBackOff**: check env vars / secrets. Start with `kubectl logs`.
- **No GPU nodes**: scale GPU node group in AWS console or `terraform apply` with larger max_size.
