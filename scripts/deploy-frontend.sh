#!/usr/bin/env bash
# Copyright 2025 Google LLC
#
# Deploy frontend to Firebase Hosting via Cloud Build.
# Uses cloudbuild-deploy.yaml which injects secrets and builds with production config.
# Run from repo root.
#
# Usage:
#   ./scripts/deploy-frontend.sh
#   PROJECT_ID=my-project ./scripts/deploy-frontend.sh
#
# Env vars (optional, defaults match dev-infra):
#   PROJECT_ID          GCP project (default: mbaneshi-cstudio-2025)
#   FIREBASE_SITE_ID    Firebase Hosting site (default: mbaneshi-cstudio-2025)
#   BACKEND_SERVICE     Cloud Run service for /api rewrites (default: cstudio-be)
#   FRONTEND_URL        Full URL of the deployed frontend (default: https://mbaneshi-cstudio-2025.web.app)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROJECT_ID="${PROJECT_ID:-mbaneshi-cstudio-2025}"
FIREBASE_SITE_ID="${FIREBASE_SITE_ID:-mbaneshi-cstudio-2025}"
BACKEND_SERVICE="${BACKEND_SERVICE:-cstudio-be}"
FRONTEND_URL="${FRONTEND_URL:-https://mbaneshi-cstudio-2025.web.app}"

echo "Deploying frontend to Firebase Hosting..."
echo "  Project: $PROJECT_ID"
echo "  Site: $FIREBASE_SITE_ID"
echo "  Backend URL: $FRONTEND_URL/api"
echo ""

cd "$REPO_ROOT"

gcloud builds submit . \
  --config=frontend/cloudbuild-deploy.yaml \
  --project="$PROJECT_ID" \
  --substitutions="_BACKEND_URL=$FRONTEND_URL,_BACKEND_SERVICE_ID=$BACKEND_SERVICE,_FIREBASE_SITE_ID=$FIREBASE_SITE_ID,_FE_SERVICE_NAME=cstudio-fe"

echo ""
echo "Frontend deployed successfully to $FRONTEND_URL"
