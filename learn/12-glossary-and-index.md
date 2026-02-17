# Chapter 12 — Glossary & Index

## Glossary

| Term | Meaning |
|------|---------|
| **ADC** | Application Default Credentials — used by Cloud Run to call GCP APIs |
| **DTO** | Data Transfer Object — request/response shape at API boundary |
| **GCS** | Google Cloud Storage |
| **IAP** | Identity-Aware Proxy — protects Cloud Run in production |
| **JIT** | Just-In-Time — user created on first API call |
| **OIDC** | OpenID Connect — token format used by Identity Platform |
| **Presigned URL** | Temporary GCS URL for direct upload/download |
| **R2V** | Reference-to-Video — image-to-video in Veo |
| **VTO** | Virtual Try-On |
| **Vertex AI** | GCP service for Imagen, Veo, Gemini |

---

## File Index (Key Paths)

### Backend

| Path | Purpose |
|------|---------|
| `backend/main.py` | Entry point, routers, lifespan |
| `backend/src/database.py` | AsyncSession, engine |
| `backend/src/auth/auth_guard.py` | get_current_user, RoleChecker |
| `backend/src/auth/firebase_client_service.py` | Firebase Admin init |
| `backend/src/common/base_repository.py` | BaseRepository |
| `backend/src/common/storage_service.py` | GcsService |
| `backend/src/images/imagen_service.py` | Imagen API calls |
| `backend/src/videos/veo_service.py` | Veo API calls |
| `backend/src/multimodal/gemini_service.py` | Gemini API calls |
| `backend/src/brand_guidelines/brand_guideline_service.py` | PDF upload, presigned URLs |

### Frontend

| Path | Purpose |
|------|---------|
| `frontend/src/app/app.module.ts` | Root module |
| `frontend/src/app/app-routing.module.ts` | Routes |
| `frontend/src/app/auth.interceptor.ts` | Bearer token injection |
| `frontend/src/app/common/services/auth.service.ts` | Auth service |
| `frontend/src/app/common/services/auth.guard.service.ts` | Route guard |
| `frontend/src/environments/` | Environment config |

### Infrastructure

| Path | Purpose |
|------|---------|
| `infra/modules/platform/` | Platform module |
| `infra/modules/cloud-run-service/` | Backend deployment |
| `infra/modules/firebase-hosting-service/` | Frontend deployment |
| `infra/environments/dev-infra/` | Dev environment |

---

## Further Reading

- [Root README](../README.md)
- [docs/LOCAL_DEV_SETUP.md](../docs/LOCAL_DEV_SETUP.md)
- [docs/FIREBASE_RECOVERY.md](../docs/FIREBASE_RECOVERY.md)
- [docs/TERRAFORM_PLAN_EXPLAINED.md](../docs/TERRAFORM_PLAN_EXPLAINED.md)
- [docs/TERRAFORM_APPLY_OUTPUT_EXPLAINED.md](../docs/TERRAFORM_APPLY_OUTPUT_EXPLAINED.md)
- [infra/README.md](../infra/README.md)

---

← [Back to learn/README](./README.md)
