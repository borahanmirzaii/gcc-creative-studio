# Chapter 4 — Backend Auth

## Overview

The backend uses **Bearer tokens** (Firebase ID tokens or Google OIDC tokens) for authentication. Most protected routes depend on `get_current_user`.

---

## Auth Flow

1. User signs in via **Firebase Auth** (local) or **Identity Platform** (dev/prod).
2. Frontend receives an ID token and sends it as `Authorization: Bearer <token>`.
3. Backend calls `get_current_user`:
   - Verifies the token
   - Extracts email, name, picture
   - Optionally checks `IDENTITY_PLATFORM_ALLOWED_ORGS`
   - **JIT provisioning:** creates user in DB if not exists
   - Returns `UserModel`

---

## Token Verification

| Environment | Method | Purpose |
|-------------|--------|---------|
| `local` | Firebase Admin `auth.verify_id_token` | Firebase Auth tokens |
| `development` / `production` | `id_token.verify_oauth2_token` with `GOOGLE_TOKEN_AUDIENCE` | Identity Platform (OIDC) tokens |

The audience is the OAuth 2.0 Web Client ID.

---

## JIT (Just-In-Time) Provisioning

On first API call, if the user does not exist in the database, the system creates a user record using email, name, and picture from the token. No separate sign-up endpoint is needed.

---

## Role-Based Access

`RoleChecker` is a dependency that enforces roles:

```python
# Example: Admin-only route
admin_only = RoleChecker([UserRoleEnum.ADMIN])

@router.get("/admin/users", dependencies=[Depends(admin_only)])
async def list_users(...):
    ...
```

---

## Key Files

| File | Role |
|------|------|
| `auth/auth_guard.py` | `get_current_user`, `RoleChecker`, `oauth2_scheme` |
| `auth/firebase_client_service.py` | Firebase Admin SDK init |
| `auth/iam_signer_credentials_service.py` | GCS presigned URL signing (service account) |
| `config/config_service.py` | `ENVIRONMENT`, `GOOGLE_TOKEN_AUDIENCE`, `ALLOWED_ORGS` |

---

## Presigned URLs

Large uploads (e.g. brand guideline PDFs) use **GCS presigned URLs** so the frontend uploads directly to GCS, avoiding backend timeouts. The backend generates the URL using `IamSignerCredentials` and the `cs-development-read` service account.

---

## Next

→ [Chapter 5: Backend Features](./05-backend-features.md)
