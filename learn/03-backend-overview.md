# Chapter 3 — Backend Overview

## Entry Point

The backend starts at `backend/main.py`. It creates a FastAPI app, configures CORS, registers routers, and sets up lifespan logic.

---

## Application Setup

```python
# backend/main.py
app = FastAPI(
    lifespan=lifespan,
    title="Creative Studio API",
    ...
)
configure_cors(app)
app.include_router(imagen_router)
app.include_router(audio_router)
# ... etc
```

---

## Lifespan

The `lifespan` context manager handles:

1. **Startup**
   - Initialize Firebase Admin SDK (auth)
   - Run database migrations (`run_pending_migrations`)
   - Create `ThreadPoolExecutor` for CPU-heavy work (e.g. image processing)

2. **Shutdown**
   - Shutdown the executor cleanly

---

## Routers (Feature Modules)

| Router | Prefix | Purpose |
|--------|--------|---------|
| imagen_router | `/api/images` | Image generation (Imagen), upscale, VTO |
| video_router | `/api/videos` | Video generation (Veo) |
| audio_router | `/api/audios` | Text-to-speech |
| gallery_router | `/api/galleries` | Media galleries |
| gemini_router | `/api/gemini` | Prompt enhancement, multimodal critic |
| user_router | `/api/users` | User management |
| workspace_router | `/api/workspaces` | Workspaces, invites |
| media_template_router | `/api/media-templates` | Prompt templates |
| source_asset_router | `/api/source-assets` | Garments, models (VTO) |
| brand_guideline_router | `/api/brand-guidelines` | PDF upload, presigned URLs |
| generation_options_router | `/api/generation-options` | Model config (aspect ratio, etc.) |

---

## CORS

- **Production:** Only `FRONTEND_URL` is allowed.
- **Development/Local:** All origins (`*`) for easier local dev.

---

## Exception Handling

A global exception handler catches unhandled errors and returns a generic 500 JSON response while logging full stack traces.

---

## Backend Module Layout

```
backend/src/
├── main.py (imported from backend/)
├── config/           # config_service, logger_config
├── database.py      # AsyncSession, engine
├── database_migrations.py
├── auth/            # auth_guard, firebase_client, iam_signer
├── common/          # base_dto, base_repository, storage_service
├── images/          # imagen controller, service, repository
├── videos/          # veo controller, service
├── audios/          # audio controller, service
├── galleries/       # gallery controller, service
├── multimodal/     # gemini controller, service
├── users/           # user controller, service, repository
├── workspaces/      # workspace controller, service
├── media_templates/ # templates controller, service
├── source_assets/   # source assets controller, service
└── brand_guidelines/# brand guideline controller, service
```

---

## Next

→ [Chapter 4: Backend Auth](./04-backend-auth.md)
