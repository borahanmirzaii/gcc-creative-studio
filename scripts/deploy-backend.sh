#!/usr/bin/env bash
# Copyright 2025 Google LLC
#
# Deploy backend to Cloud Run via Cloud Build.
# Run from repo root. Works for both manual and CI.
#
# Usage:
#   ./scripts/deploy-backend.sh
#   PROJECT_ID=my-project ./scripts/deploy-backend.sh
#
# Env vars (optional, defaults match dev-infra):
#   PROJECT_ID          GCP project (default: mbaneshi-cstudio-2025)
#   BACKEND_SERVICE     Cloud Run service name (default: cstudio-be)
#   REGION              GCP region (default: us-central1)
#   REPO_NAME           Artifact Registry repo (default: cs-be-development-repo)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROJECT_ID="${PROJECT_ID:-mbaneshi-cstudio-2025}"
BACKEND_SERVICE="${BACKEND_SERVICE:-cstudio-be}"
REGION="${REGION:-us-central1}"
REPO_NAME="${REPO_NAME:-cs-be-development-repo}"

# Use git short SHA for manual builds; Cloud Build trigger uses SHORT_SHA
IMAGE_TAG="${IMAGE_TAG:-$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "manual")}"

echo "Deploying backend to Cloud Run..."
echo "  Project: $PROJECT_ID"
echo "  Service: $BACKEND_SERVICE"
echo "  Image tag: $IMAGE_TAG"
echo ""

cd "$REPO_ROOT"

gcloud builds submit . \
  --config=backend/cloudbuild.yaml \
  --project="$PROJECT_ID" \
  --substitutions="_SERVICE_NAME=$BACKEND_SERVICE,_REGION=$REGION,_REPO_NAME=$REPO_NAME,_IMAGE_TAG=$IMAGE_TAG"

echo ""
echo "Backend deployed successfully."
