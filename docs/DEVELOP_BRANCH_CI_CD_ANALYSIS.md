# Develop Branch CI/CD Analysis

This document explains what happens when you push to `develop` and identifies potential causes of the login/localhost issue.

---

## 1. What Triggers on Push to `develop`

Terraform configures **two Cloud Build triggers** connected to your GitHub repo via Cloud Build v2:

| Trigger | Fires when | Config file | Deploys to |
|---------|------------|-------------|------------|
| **Backend** | `backend/**` changes | `backend/cloudbuild.yaml` | Cloud Run `cstudio-be` |
| **Frontend** | `frontend/**` changes | `frontend/cloudbuild-deploy.yaml` | Firebase Hosting `mbaneshi-cstudio-2025` |

**GitHub connection:** `gh-repo-owner-con` → `borahanmirzaii/gcc-creative-studio` (from `dev-infra.tfvars`)

---

## 2. Frontend Deploy Flow (Correct Behavior)

When `frontend/**` changes and the trigger runs:

1. **cloudbuild-deploy.yaml** runs (NOT `cloudbuild.yaml`)
2. **Step 2:** Injects into `environment.prod.ts`:
   - `BACKEND_URL_PLACEHOLDER` → `https://mbaneshi-cstudio-2025.web.app/api` (from `_BACKEND_URL`)
   - Firebase config, `GOOGLE_CLIENT_ID` from Secret Manager
3. **Step 3:** Builds with `npm run build -- --configuration=production` → uses **environment.prod.ts**
4. **Step 4:** Deploys to Firebase Hosting

**Result:** Production build with correct `backendURL` (same-origin, Firebase rewrites `/api/**` to Cloud Run).

---

## 3. Why the Live Site Was Calling `localhost:8080`

The deployed frontend had `backendURL: 'http://localhost:8080/api'` — that comes from **environment.development.ts**, which is used by:

- `pnpm run build` (default) → `build-dev` config
- `pnpm run build-dev`
- `ng build --configuration build-dev`

**Most likely cause:** The frontend was deployed **manually** (not via the Cloud Build trigger), e.g.:

```bash
cd frontend
pnpm run build          # Uses build-dev → localhost!
firebase deploy
```

Or a script/CI that runs `build` without `--configuration=production`.

---

## 4. Potential Issues in Current Setup

### A. `fe_build_substitutions` has `_ANGULAR_BUILD_COMMAND = "build-dev"`

**Location:** `infra/environments/dev-infra/dev-infra.tfvars`

```hcl
fe_build_substitutions = {
  _ANGULAR_BUILD_COMMAND = "build-dev"
}
```

**Impact:** None for the frontend trigger. The trigger uses `cloudbuild-deploy.yaml`, which hardcodes `--configuration=production` and does **not** use `_ANGULAR_BUILD_COMMAND`. This variable is only used by `frontend/cloudbuild.yaml`, which is **not** used by the Terraform trigger.

**Recommendation:** Can be removed or set to `build-prd` for clarity if you ever switch to a different pipeline.

### B. `frontend/cloudbuild.yaml` exists but is NOT used by the trigger

`frontend/cloudbuild.yaml` uses `_ANGULAR_BUILD_COMMAND` (default `build-dev`) and then triggers `cloudbuild-deploy.yaml`. The Terraform trigger uses `cloudbuild-deploy.yaml` directly, so this file is unused. No change needed unless you intentionally switch pipelines.

### C. GitHub connection must exist and be authorized

The triggers depend on `google_cloudbuildv2_repository` and connection `gh-repo-owner-con`. If the connection is broken, expired, or points to the wrong repo, pushes will not trigger builds.

**Verify:**
```bash
gcloud builds triggers list --project=mbaneshi-cstudio-2025 --region=us-central1
```

### D. `included_files` — only matching paths trigger

- Backend trigger: `backend/**` — only backend changes
- Frontend trigger: `frontend/**` — only frontend changes

Pushing only `infra/`, `docs/`, or root files will **not** trigger either build.

---

## 5. Recommended Fixes

### Fix 1: Use the deploy scripts (preferred)

```bash
./scripts/deploy-frontend.sh   # Uses Cloud Build, injects correct config
./scripts/deploy-backend.sh    # Deploys backend to Cloud Run
```

See `docs/DEPLOY.md` for full documentation.

### Fix 2: Avoid direct `firebase deploy` with `pnpm run build`

Direct `pnpm run build` + `firebase deploy` uses `build-dev` → localhost. Always use Cloud Build for production.

---

## 6. Summary

| Item | Status |
|------|--------|
| Terraform trigger uses `cloudbuild-deploy.yaml` | ✅ Correct |
| `cloudbuild-deploy` uses `--configuration=production` | ✅ Correct |
| `_BACKEND_URL` from Terraform = frontend URL | ✅ Correct |
| Manual `pnpm run build` + `firebase deploy` | ❌ Uses localhost |
| Backend trigger (placeholder image) | ❌ Was running `hello` image; fixed by manual `gcloud builds submit` |

**Root cause of login failure:** Frontend was likely deployed with development config (localhost), and backend was running the placeholder `hello` image instead of the FastAPI app.
