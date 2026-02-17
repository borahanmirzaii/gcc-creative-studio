# Terraform Apply Output Explained

This document explains the **live output** you see when running `terraform apply` for Creative Studio. It describes what each message means as resources are created.

---

## Output Structure

Terraform prints lines like:
```
resource_name: Creating...
resource_name: Creation complete after Xs [id=...]
resource_name: Still creating... [Xs elapsed]
```

| Message | Meaning |
|---------|---------|
| `Creating...` | Terraform has started creating the resource |
| `Still creating... [Xs elapsed]` | Resource is taking longer; Terraform is polling |
| `Creation complete after Xs` | Resource is ready; Terraform recorded its ID |

---

## Phase 1: API Enablement (~1–2 min)

```
google_project_service.apis["run.googleapis.com"]: Creating...
google_project_service.apis["compute.googleapis.com"]: Still creating... [1m0s elapsed]
google_project_service.apis["compute.googleapis.com"]: Creation complete after 1m16s
```

**What it does:** Enables GCP APIs on the project. Each API is enabled in parallel. `compute` and `texttospeech` often take longer (up to ~1–2 minutes).

---

## Phase 2: Data Sources (Read-Only)

```
module.creative_studio_platform.data.google_project.project: Reading...
module.creative_studio_platform.data.google_project.project: Read complete after 1s [id=projects/mbaneshi-cstudio-2025]

module.creative_studio_platform.data.google_secret_manager_secret_version.db_password: Reading...
module.creative_studio_platform.data.google_secret_manager_secret_version.db_password: Read complete after 1s [id=projects/519791639027/secrets/creative-studio-db-password/versions/1]
```

**What it does:** Reads existing data (project metadata, DB password from Secret Manager). No resources are created.

---

## Phase 3: Foundation Resources

### Random ID (for Cloud SQL instance name)
```
module.creative_studio_platform.module.postgresql.random_id.db_name_suffix: Creation complete after 0s [id=Ha3ofQ]
```
**Purpose:** Random suffix for the Cloud SQL instance (e.g. `creative-studio-db-Ha3ofQ`).

### Firebase
```
module.creative_studio_platform.google_firebase_project.default: Creation complete after 1s
```
**Purpose:** Links Firebase to the GCP project (often already done if you added Firebase earlier).

### GCS Bucket
```
module.creative_studio_platform.google_storage_bucket.genmedia: Creation complete after 3s [id=mbaneshi-cstudio-2025-cs-development-bucket]
```
**Purpose:** Bucket for images, videos, and other assets.

### Cloud Build Repository Link
```
module.creative_studio_platform.google_cloudbuildv2_repository.source_repo: Creation complete after 14s [id=.../connections/gh-repo-owner-con/repositories/gcc-creative-studio]
```
**Purpose:** Connects the GitHub repo to Cloud Build for triggers.

### Artifact Registry
```
module.creative_studio_platform.module.backend_service.google_artifact_registry_repository.repo: Creation complete after 14s [id=.../repositories/cs-be-development-repo]
```
**Purpose:** Docker registry for backend images.

---

## Phase 4: Secret Manager Secrets

```
module.creative_studio_platform.module.frontend_secrets.google_secret_manager_secret.this["FIREBASE_API_KEY"]: Creation complete after 1s
module.creative_studio_platform.module.frontend_secrets.google_secret_manager_secret.this["GOOGLE_CLIENT_ID"]: Creation complete after 2s
...
```

**What it does:** Creates Secret Manager secrets (shells only, no values yet). Values are filled by `update_secrets.sh` later. Secrets include:
- `FIREBASE_API_KEY`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_PROJECT_ID`, etc.
- `GOOGLE_CLIENT_ID`, `GOOGLE_TOKEN_AUDIENCE`

---

## Phase 5: Service Accounts

```
module.creative_studio_platform.google_service_account.bucket_reader_sa: Creation complete after 22s [id=.../cs-development-read@...]
module.creative_studio_platform.module.backend_service.google_service_account.trigger_sa: Creation complete after 29s
module.creative_studio_platform.module.backend_service.google_service_account.run_sa: Creation complete after 33s
module.creative_studio_platform.module.frontend_service.google_service_account.trigger_sa: Creation complete after 14s
```

| Service Account | Role |
|-----------------|------|
| `cs-development-read` | Signs GCS URLs for frontend uploads |
| `cs-be-development-trig` | Runs Cloud Build for backend |
| `cs-be-development-run` | Runtime identity for Cloud Run backend |
| `cs-fe-development-trig` | Runs Cloud Build for frontend |

---

## Phase 6: IAM Bindings

```
module.creative_studio_platform.google_storage_bucket_iam_member.bucket_viewer_binding: Creation complete after 12s
module.creative_studio_platform.module.backend_service.google_project_iam_member.cloudsql_client: Creating...
module.creative_studio_platform.module.backend_service.google_project_iam_member.aiplatform_user_binding: Creating...
...
```

**What it does:** Grants roles to service accounts (e.g. Cloud SQL client, Vertex AI user, Storage admin, Secret Manager accessor).

---

## Phase 7: Cloud SQL (Slowest Step)

```
module.creative_studio_platform.module.postgresql.google_sql_database_instance.default: Creating...
module.creative_studio_platform.module.postgresql.google_sql_database_instance.default: Still creating... [30s elapsed]
...
```

**Expected duration:** ~5–10 minutes. A PostgreSQL instance is being provisioned. Terraform will then create the database and user.

---

## Phase 8: Cloud Build Triggers

```
module.creative_studio_platform.module.frontend_service.google_cloudbuild_trigger.this: Creation complete after 2s
module.creative_studio_platform.module.backend_service.google_cloudbuild_trigger.this: Creation complete after 2s
```

**Purpose:** Triggers that run on push to `develop` to build and deploy frontend and backend.

---

## Phase 9: Firebase Hosting Site

```
module.creative_studio_platform.module.frontend_service.google_firebase_hosting_site.this: Creation complete after 2s [id=projects/mbaneshi-cstudio-2025/sites/mbaneshi-cstudio-2025]
```

**Purpose:** Hosting site used for the deployed frontend.

---

## Typical Order of Creation

1. APIs (~1–2 min)
2. Data reads (~1 s)
3. Random ID, Firebase, GCS bucket (~5 s)
4. Cloud Build repo link, Artifact Registry (~15 s)
5. Secret Manager secrets (~5 s)
6. Service accounts (~30 s)
7. IAM bindings (~10–15 s)
8. Cloud SQL instance (~5–10 min) — **blocking step**
9. Cloud SQL database and user (after instance)
10. Cloud Run service (after Cloud SQL)
11. Cloud Build triggers (~2 s)
12. Firebase Hosting site (~2 s)

---

## When It Finishes

At the end you should see:
```
Apply complete! Resources: 61 added, 0 changed, 0 destroyed.

Outputs:
cloud_sql_connection_name = "mbaneshi-cstudio-2025:us-central1:creative-studio-db-xxxxx"
gcp_project_id = "mbaneshi-cstudio-2025"
...
```

Use `cloud_sql_connection_name` in `backend/.env` as `INSTANCE_CONNECTION_NAME`.
