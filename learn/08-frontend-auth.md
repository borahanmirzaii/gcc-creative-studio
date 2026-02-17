# Chapter 8 — Frontend Auth

## Overview

The frontend uses **Firebase Auth** (local) or **Identity Platform** (prod) for sign-in. The ID token is sent with every API request via an HTTP interceptor.

---

## Auth Service

`common/services/auth.service.ts`:

- **Sign in:** Google sign-in (popup or redirect)
- **Sign out**
- **Token:** `getIdToken()` for API calls
- **User state:** Observable for current user
- **Environment:** `isLocal` → Firebase Auth; otherwise Identity Platform

---

## Auth Guard

`AuthGuardService` (`common/services/auth.guard.service.ts`):

- Used in routes: `canActivate: [AuthGuardService]`
- If not authenticated → redirect to `/login`
- If authenticated → allow navigation

---

## Admin Guard

`AdminAuthGuard` (`admin/admin-auth.guard.ts`):

- Checks if user has admin role
- Used for `/admin` routes
- Redirects non-admins (e.g. to home)

---

## Login Component

`login/login.component.ts`:

- Renders sign-in UI (Google button)
- Calls `authService.signInWithGoogle()`
- On success → navigate to home or intended URL
- Handles OAuth errors

---

## Token Refresh

The auth service (or interceptor) should refresh the token when expired. Firebase SDK handles this; the interceptor uses the current token from the auth service.

---

## Environment Config

`environment.development.ts` and `environment.prod.ts` include:

- `firebase` config (apiKey, authDomain, projectId, etc.)
- `GOOGLE_CLIENT_ID` — OAuth client ID
- `isLocal` — use Firebase Auth vs Identity Platform
- `backendURL` — API base URL

---

## Next

→ [Chapter 9: Frontend Features](./09-frontend-features.md)
