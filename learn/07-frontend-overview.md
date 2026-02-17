# Chapter 7 — Frontend Overview

## Technology

- **Angular** (standalone components where applicable)
- **TypeScript**
- **Angular Material** — UI components
- **Tailwind CSS** — styling
- **RxJS** — reactive state and HTTP

---

## Directory Layout

```
frontend/src/
├── main.ts              # Bootstrap
├── index.html
├── app/
│   ├── app.module.ts    # Root module
│   ├── app-routing.module.ts
│   ├── app.component.*
│   ├── admin/           # Lazy-loaded admin module
│   ├── arena/            # Arena page
│   ├── home/
│   ├── login/
│   ├── video/
│   ├── vto/
│   ├── audio/
│   ├── gallery/
│   ├── fun-templates/
│   ├── common/          # Shared components, services, models
│   ├── components/
│   ├── services/
│   └── utils/
└── environments/        # environment.ts, environment.development.ts, etc.
```

---

## App Module

`app.module.ts` imports:

- `HttpClientModule`
- `SharedModule` — common components
- `AppRoutingModule`
- Feature modules (Home, Login, Arena, Video, etc.)
- Admin module is **lazy-loaded** via router

---

## Routing

`app-routing.module.ts`:

| Path | Component | Guard |
|------|-----------|-------|
| `/login` | LoginComponent | — |
| `/` | HomeComponent | AuthGuardService |
| `/fun-templates` | FunTemplatesComponent | AuthGuardService |
| `/video` | VideoComponent | AuthGuardService |
| `/arena` | ArenaComponent | AuthGuardService |
| `/vto` | VtoComponent | AuthGuardService |
| `/audio` | AudioComponent | AuthGuardService |
| `/gallery` | MediaGalleryComponent | — |
| `/gallery/:id` | MediaDetailComponent | — |
| `/admin` | AdminModule (lazy) | AdminAuthGuard |

---

## Environments

- `environment.ts` — Base config
- `environment.development.ts` — Local dev (Firebase, `backendURL`, `isLocal`)
- `environment.prod.ts` — Production (Firebase Hosting URL, prod backend)

---

## HTTP and Auth Interceptor

`auth.interceptor.ts` attaches the Bearer token to outgoing requests:

```typescript
// Adds: Authorization: Bearer <id_token>
```

---

## Shared Module

`common/shared.module.ts` exports:

- Common components (toast, confirmation dialog, workspace switcher, etc.)
- Pipes, directives used across the app

---

## Next

→ [Chapter 8: Frontend Auth](./08-frontend-auth.md)
