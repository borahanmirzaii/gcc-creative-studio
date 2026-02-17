# Chapter 2 — Infrastructure

## Overview

Infrastructure is managed with **Terraform** using a modular, environment-based layout. See [infra/README.md](../infra/README.md) for the official overview.

---

## Directory Structure

```
infra/
├── modules/                    # Reusable blueprints
│   ├── platform/              # Main entry: entire application platform
│   ├── cloud-run-service/     # Backend (Cloud Run, triggers, etc.)
│   ├── firebase-hosting-service/  # Frontend (Firebase Hosting, triggers)
│   ├── postgresql/            # Cloud SQL instance
│   └── secret-manager/        # Secrets for frontend/backend
└── environments/
    ├── dev-infra-example/     # Example tfvars
    └── dev-infra/             # Your dev environment
        ├── main.tf
        ├── backend.tf         # Terraform state location
        └── dev-infra.tfvars   # Variables
```

---

## Key GCP Resources

| Resource | Purpose |
|----------|---------|
| Cloud SQL | PostgreSQL for users, galleries, media metadata |
| Cloud Run | Backend API (cstudio-be) |
| Firebase Hosting | Frontend SPA (cstudio-fe) |
| GCS Bucket | Media storage (images, videos, PDFs) |
| Secret Manager | DB password, Firebase config, OAuth client ID |
| Artifact Registry | Docker images for Cloud Run |
| Cloud Build | CI/CD triggers on `develop` branch |
| IAP | Identity-Aware Proxy (prod) |

---

## Platform Module

The `platform` module composes:

- Firebase project
- Cloud Build repository (GitHub connection)
- GCS bucket + IAM
- PostgreSQL (Cloud SQL)
- Backend service (Cloud Run + trigger)
- Frontend service (Firebase Hosting + trigger)
- Secret Manager secrets (backend + frontend)
- Service accounts (bucket reader, run, trigger)

---

## CI/CD Flow

1. **Push to `develop`** → Cloud Build triggers
2. **Backend:** Build Docker image → push to Artifact Registry → deploy to Cloud Run
3. **Frontend:** Build Angular → deploy to Firebase Hosting

---

## Related Docs

- [docs/TERRAFORM_PLAN_EXPLAINED.md](../docs/TERRAFORM_PLAN_EXPLAINED.md) — Plan output explained
- [docs/TERRAFORM_APPLY_OUTPUT_EXPLAINED.md](../docs/TERRAFORM_APPLY_OUTPUT_EXPLAINED.md) — Apply output explained

---

## Next

→ [Chapter 3: Backend Overview](./03-backend-overview.md)
