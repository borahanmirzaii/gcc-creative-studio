# Chapter 5 — Backend Features

Each feature is organized as a **module** with controller → service → repository (when DB is used). DTOs define request/response shapes.

---

## Images (`/api/images`)

**Purpose:** Image generation with Imagen, upscaling, and Virtual Try-On.

- **Endpoints:** Create image, upscale, VTO
- **Service:** `ImagenService` — calls Vertex AI Imagen API
- **Repository:** `MediaRepository` — media items in PostgreSQL
- **Background jobs:** VTO runs in `ProcessPoolExecutor` for long CPU work
- **Storage:** GCS (`GENMEDIA_BUCKET`)

---

## Videos (`/api/videos`)

**Purpose:** Video generation with Veo (text-to-video, image-to-video).

- **Endpoints:** Create video, concatenate
- **Service:** `VeoService` — Vertex AI Veo API
- **Storage:** GCS for output videos

---

## Audios (`/api/audios`)

**Purpose:** Text-to-speech with Vertex AI (Cloud TTS).

- **Endpoints:** Create audio, list voices
- **Service:** `AudioService`

---

## Galleries (`/api/galleries`)

**Purpose:** Media gallery—list and search images/videos.

- **Endpoints:** Search, get by ID
- **Service:** `GalleryService` — aggregates media items
- **Repository:** Uses `MediaRepository`

---

## Multimodal / Gemini (`/api/gemini`)

**Purpose:** Prompt enhancement and multimodal critic.

- **Endpoints:** Enhance prompt (Imagen/Video), critique image
- **Service:** `GeminiService` — Vertex AI Gemini
- **Rewriters:** Different prompt strategies for Imagen vs Veo

---

## Brand Guidelines (`/api/brand-guidelines`)

**Purpose:** Upload PDF style guides, extract brand info with Gemini.

- **Flow:**
  1. `generate_upload_url` → returns presigned GCS URL
  2. Frontend uploads PDF directly to GCS
  3. `finalize_upload` → backend processes in background (split large PDFs, extract text with Gemini)
- **Service:** `BrandGuidelineService`
- **Repository:** `BrandGuidelineRepository`
- **Background:** `ProcessPoolExecutor` for PDF processing

---

## Workspaces (`/api/workspaces`)

**Purpose:** Multi-tenant workspaces; users can belong to multiple workspaces.

- **Endpoints:** Create, list, invite users
- **Service:** `WorkspaceService`
- **Repository:** `WorkspaceRepository`
- **Guard:** `WorkspaceAuthGuard` — workspace-scoped access

---

## Users (`/api/users`)

**Purpose:** User management (CRUD), used by admin and JIT provisioning.

- **Endpoints:** Create, search, update
- **Service:** `UserService`
- **Repository:** `UserRepository`
- **Admin-only:** Some routes use `RoleChecker([UserRoleEnum.ADMIN])`

---

## Media Templates (`/api/media-templates`)

**Purpose:** Reusable prompt templates for different media types.

- **Endpoints:** CRUD for templates
- **Service:** `MediaTemplatesService`
- **Repository:** `MediaTemplateRepository`

---

## Source Assets (`/api/source-assets`)

**Purpose:** Garments, models, etc. for Virtual Try-On.

- **Endpoints:** CRUD, search
- **Service:** `SourceAssetService`
- **Repository:** `SourceAssetRepository`
- **Admin:** Management via admin UI

---

## Generation Options (`/api/generation-options`)

**Purpose:** Model config (aspect ratio, style, etc.) exposed to frontend.

- **Endpoints:** Get options
- **Controller:** Read-only, no service layer

---

## Next

→ [Chapter 6: Backend Patterns](./06-backend-patterns.md)
