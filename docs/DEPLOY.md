# Deployment Guide

This document describes the correct way to deploy Creative Studio frontend and backend.

---

## TL;DR — Use the scripts

```bash
# From repo root
./scripts/deploy-backend.sh   # Deploy backend to Cloud Run
./scripts/deploy-frontend.sh  # Deploy frontend to Firebase Hosting
```

---

## Why Cloud Build (not direct `firebase deploy`)

The frontend must be built with **production config** (`environment.prod.ts`) so that:

- `backendURL` = `https://<your-site>.web.app/api` (same-origin; Firebase rewrites `/api/**` to Cloud Run)
- Firebase config and `GOOGLE_CLIENT_ID` are injected from Secret Manager

If you run `pnpm run build` (default = `build-dev`) and then `firebase deploy`, the app will call `http://localhost:8080` and login will fail.

**Always use Cloud Build** for production deploys so secrets are injected correctly.

---

## Deploy Backend

Builds the FastAPI container, pushes to Artifact Registry, and deploys to Cloud Run.

```bash
./scripts/deploy-backend.sh
```

Or with custom values:

```bash
PROJECT_ID=my-project BACKEND_SERVICE=my-be ./scripts/deploy-backend.sh
```

**Manual gcloud (equivalent):**

```bash
gcloud builds submit . \
  --config=backend/cloudbuild.yaml \
  --project=mbaneshi-cstudio-2025 \
  --substitutions=_SERVICE_NAME=cstudio-be,_REGION=us-central1,_REPO_NAME=cs-be-development-repo,_IMAGE_TAG=$(git rev-parse --short HEAD 2>/dev/null || echo manual)
```

---

## Deploy Frontend

Injects secrets, builds with production config, and deploys to Firebase Hosting.

```bash
./scripts/deploy-frontend.sh
```

Or with custom values:

```bash
PROJECT_ID=my-project FIREBASE_SITE_ID=my-site ./scripts/deploy-frontend.sh
```

**Manual gcloud (equivalent):**

```bash
gcloud builds submit . \
  --config=frontend/cloudbuild-deploy.yaml \
  --project=mbaneshi-cstudio-2025 \
  --substitutions=_BACKEND_URL=https://mbaneshi-cstudio-2025.web.app,_BACKEND_SERVICE_ID=cstudio-be,_FIREBASE_SITE_ID=mbaneshi-cstudio-2025,_FE_SERVICE_NAME=cstudio-fe
```

---

## GitHub Triggers (push to `develop`)

When you push to `develop`:

| Path changed | Trigger | Deploys |
|--------------|---------|---------|
| `backend/**` | Backend Cloud Build | Cloud Run `cstudio-be` |
| `frontend/**` | Frontend Cloud Build | Firebase Hosting |

The triggers use the same Cloud Build configs and get substitutions from Terraform. Ensure the GitHub connection (`gh-repo-owner-con`) is configured and authorized.

---

## Wrong way (causes localhost / login failure)

```bash
# DON'T do this for production
cd frontend
pnpm run build          # Uses build-dev → backendURL = localhost:8080
firebase deploy         # Deploys broken config
```

---

## Environment variables for scripts

| Variable | Default | Description |
|----------|---------|-------------|
| `PROJECT_ID` | `mbaneshi-cstudio-2025` | GCP project |
| `BACKEND_SERVICE` | `cstudio-be` | Cloud Run service name |
| `FIREBASE_SITE_ID` | `mbaneshi-cstudio-2025` | Firebase Hosting site |
| `FRONTEND_URL` | `https://mbaneshi-cstudio-2025.web.app` | Full frontend URL (for backendURL) |
| `REGION` | `us-central1` | GCP region |
| `REPO_NAME` | `cs-be-development-repo` | Artifact Registry repo |
