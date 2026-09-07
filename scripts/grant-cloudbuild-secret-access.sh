#!/usr/bin/env bash
# Grant Cloud Build service accounts access to frontend secrets for manual gcloud builds submit.
# Run from repo root. Requires gcloud auth.

set -euo pipefail

PROJECT_ID="${PROJECT_ID:-mbaneshi-cstudio-2025}"
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')

# Both Cloud Build 1st gen and 2nd gen SAs (manual submit may use either)
SA_LEGACY="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
SA_2ND_GEN="service-${PROJECT_NUMBER}@gcp-sa-cloudbuild.iam.gserviceaccount.com"

SECRETS=(FIREBASE_API_KEY FIREBASE_AUTH_DOMAIN FIREBASE_PROJECT_ID FIREBASE_STORAGE_BUCKET \
  FIREBASE_MESSAGING_SENDER_ID FIREBASE_APP_ID FIREBASE_MEASUREMENT_ID GOOGLE_CLIENT_ID)

echo "Granting secret access to Cloud Build SAs..."
echo "  Legacy: $SA_LEGACY"
echo "  2nd gen: $SA_2ND_GEN"
echo ""

for SECRET in "${SECRETS[@]}"; do
  echo "  $SECRET..."
  for SA in "$SA_LEGACY" "$SA_2ND_GEN"; do
    gcloud secrets add-iam-policy-binding "$SECRET" \
      --project="$PROJECT_ID" \
      --member="serviceAccount:${SA}" \
      --role="roles/secretmanager.secretAccessor" \
      --quiet 2>/dev/null || true
  done
done

echo ""
echo "Done. Retry: gcloud builds submit . --config=frontend/cloudbuild-deploy.yaml --project=$PROJECT_ID ..."
