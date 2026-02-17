# Chapter 1 — Overview

## What is Creative Studio?

Creative Studio is a **Generative AI platform** on Google Cloud that showcases Imagen, Veo, and Gemini. It provides:

- **Image generation** (Imagen)
- **Video generation** (Veo, including image-to-video)
- **Audio** (Text-to-Speech)
- **Prompt enhancement** (Gemini)
- **Brand guidelines** (PDF upload, AI extraction)
- **Virtual Try-On (VTO)** foundations

---

## System Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Angular SPA    │────▶│  FastAPI Backend │────▶│  Vertex AI      │
│   (Firebase      │     │  (Cloud Run)     │     │  (Imagen, Veo,  │
│   Hosting)       │     │                  │     │   Gemini)       │
└────────┬────────┘     └────────┬────────┘     └─────────────────┘
         │                       │
         │                       ├── Cloud SQL (PostgreSQL)
         │                       ├── Firestore (user metadata)
         │                       └── GCS (media, PDFs)
         │
         └── Firebase Auth / Identity Platform (OAuth)
```

**Request flow (typical):**

1. User logs in via Firebase/Identity Platform → receives ID token.
2. Frontend sends requests with `Authorization: Bearer <token>`.
3. Backend verifies token, provisions user (JIT), and serves the request.
4. For AI calls: backend uses Vertex AI SDK → Imagen/Veo/Gemini.
5. Media stored in GCS; metadata in PostgreSQL.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Angular, TypeScript, Angular Material, Tailwind CSS |
| Backend | Python, FastAPI, Pydantic |
| Database | Cloud SQL (PostgreSQL) |
| Auth | Firebase Auth (local) / Identity Platform (prod) |
| AI | Vertex AI SDK (Imagen, Veo, Gemini) |
| Storage | Google Cloud Storage |
| Deployment | Cloud Run (backend), Firebase Hosting (frontend) |
| IaC | Terraform |

---

## Directory Layout

```
gcc-creative-studio/
├── backend/          # FastAPI application
│   ├── main.py       # Entry point
│   ├── src/          # Feature modules
│   └── cloudbuild.yaml
├── frontend/         # Angular SPA
│   ├── src/
│   │   ├── app/      # Components, services, modules
│   │   └── environments/
│   └── cloudbuild-deploy.yaml
├── infra/            # Terraform
│   ├── modules/      # Reusable modules (platform, cloud-run-service, ...)
│   └── environments/ # dev-infra, etc.
├── docs/             # Setup, Terraform, Firebase guides
└── learn/            # This mini-book
```

---

## Key Design Principles

1. **Feature-driven structure** — Code grouped by domain (images, videos, galleries), not by layer.
2. **Hexagonal-style** — Controllers → Services → Repositories; DTOs at boundaries.
3. **Environment-aware** — Local (Firebase) vs dev/prod (Identity Platform).
4. **Async backend** — FastAPI + `AsyncSession` for DB, `asyncio` for I/O.

---

## Next

→ [Chapter 2: Infrastructure](./02-infrastructure.md)
