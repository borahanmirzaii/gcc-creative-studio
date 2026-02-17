# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GCC Creative Studio is a Generative AI platform on Google Cloud showcasing Imagen (images), Veo (video), Gemini (prompt enhancement), and TTS (audio). It's a monorepo with three main components: Angular frontend, FastAPI backend, and Terraform infrastructure.

## Build & Dev Commands

### Local Development (Docker Compose)
```bash
docker compose up                    # Start both frontend (:4200) and backend (:8080) with hot reload
```

### Frontend (from `frontend/`)
```bash
pnpm install                         # Install dependencies
pnpm run start                       # Dev server on :4200 (proxies /api to backend)
pnpm run build-dev                   # Build for development
pnpm run build-qat                   # Build for QAT
pnpm run build-prd                   # Production build with AOT + output hashing
pnpm run lint                        # gts lint (Google TypeScript Style)
pnpm run fix                         # Auto-fix lint issues
pnpm run compile                     # Type-check only (tsc --noEmit)
pnpm run format                      # Prettier format
pnpm run test                        # Karma + Jasmine tests
```

### Backend (from `backend/`)
```bash
uv sync                              # Install dependencies from lock file
uvicorn main:app --reload --host 0.0.0.0 --port 8080   # Dev server with hot reload
python -m alembic upgrade head       # Run database migrations
python -m alembic revision --autogenerate -m "msg"      # Create migration
pytest                               # Run tests (includes coverage via pytest.ini)
pytest -k "test_name"                # Run specific test
python -m ruff check .               # Lint
python -m ruff format .              # Format
```

### Infrastructure (from `infra/environments/dev-infra/`)
```bash
terraform init
terraform plan -var-file=dev-infra.tfvars
terraform apply -var-file=dev-infra.tfvars
```

### Deploy to production (from repo root)
```bash
./scripts/deploy-backend.sh   # Cloud Run
./scripts/deploy-frontend.sh  # Firebase Hosting (uses Cloud Build for correct config)
```
See `docs/DEPLOY.md` for details. **Do not** use `pnpm run build` + `firebase deploy` — that bakes in localhost.

## Architecture

### Frontend: Angular 18 + Material + Tailwind
- **Package manager:** pnpm 9.15.4 (pinned in package.json, managed via mise)
- **Node version:** 20 (via `.mise.toml`)
- **Code style:** gts (Google TypeScript Style) — extends ESLint + Prettier
- **Auth:** Firebase Auth (local) / Identity Platform (prod), token injected via `AuthInterceptor` (`src/app/auth.interceptor.ts`)
- **Proxy:** Dev server proxies `/api` to backend via `proxy.conf.json`
- **Feature modules:** `src/app/{arena,video,audio,gallery,vto,admin,login,home,fun-templates}/`
- **Shared code:** `src/app/services/` (HTTP services), `src/app/common/` (shared components/directives)
- **Environment configs:** `src/environments/environment.ts` and `environment.development.ts`
- **Build configs:** `angular.json` has `development`, `build-dev`, `build-qat`, `build-prd` configurations

### Backend: FastAPI + SQLAlchemy Async + PostgreSQL
- **Package manager:** uv (Rust-based, fast)
- **Python version:** 3.12+
- **Entry point:** `main.py` — registers all routers, configures CORS, runs Alembic migrations on startup
- **Feature-driven modules** in `src/`: each has controller → service → repository → schema (SQLAlchemy model) → dto (Pydantic)
  - `images/` — Imagen generation
  - `videos/` — Veo generation
  - `audios/` — Text-to-speech
  - `multimodal/` — Gemini prompt enhancement/critic
  - `galleries/` — Media gallery management
  - `users/` — User profiles, JIT provisioning
  - `workspaces/` — Team/workspace management
  - `brand_guidelines/` — PDF upload & extraction
  - `source_assets/` — VTO garments/models
  - `media_templates/` — Prompt templates
  - `generation_options/` — Model config (aspect ratio, etc.)
- **Auth:** `src/auth/auth_guard.py` validates Firebase JWT, `RoleChecker` dependency for role-based access
- **Config:** `src/config/config_service.py` — Pydantic settings loaded from env vars / `.env`
- **Database:** Async SQLAlchemy with asyncpg driver, Cloud SQL Python Connector for production
- **Storage:** GCS with signed URLs via `src/common/storage_service.py`

### Infrastructure: Terraform (modular)
- **Modules:** `infra/modules/{platform,cloud-run-service,postgresql,secret-manager,firebase-hosting-service}/`
- **Environments:** `infra/environments/dev-infra/` (each env has its own state)
- **Deploys to:** Cloud Run (backend), Firebase Hosting (frontend), Cloud SQL (PostgreSQL), GCS (media)

## Key Conventions

- **Commit messages:** Angular convention — `type(scope): description` (e.g., `feat(frontend): add image upscaler UI`)
- **Branching:** Git Flow — `main` (production), `develop` (integration), `feature/<name>` (work branches)
- **PRs target:** `develop` branch
- **Backend line length:** ruff configured with `ignore = ["E501"]`; black uses 80 chars
- **Frontend tests:** `*.spec.ts` files co-located with components
- **API routes:** All prefixed with `/api/` (e.g., `/api/images`, `/api/videos`, `/api/users`)

## Environment Setup

Backend requires a `.env` file (see `backend/.env.example`). Key vars: `PROJECT_ID`, `ENVIRONMENT` (local/development/production), `GENMEDIA_BUCKET`, `INSTANCE_CONNECTION_NAME`, `DB_USER`, `DB_PASS`, `DB_NAME`, `SIGNING_SA_EMAIL`, `GOOGLE_TOKEN_AUDIENCE`.

Frontend requires `src/environments/environment.development.ts` with Firebase config, `GOOGLE_CLIENT_ID`, and `backendURL`. Set `isLocal: true` for Firebase Auth in dev.

GCP auth: `gcloud auth application-default login` must be run for local development.
