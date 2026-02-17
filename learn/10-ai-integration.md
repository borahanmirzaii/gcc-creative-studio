# Chapter 10 — AI Integration

## Overview

Creative Studio uses **Vertex AI** for Imagen, Veo, and Gemini. The backend calls these via the Vertex AI SDK and Google GenAI client.

---

## Imagen (Images)

- **Model:** Imagen 3 (or configured variant)
- **Endpoints:** `/api/images` (create, upscale)
- **Flow:** Prompt (optionally enhanced by Gemini) → Imagen API → image stored in GCS
- **Options:** Aspect ratio, sample count, safety filter
- **Files:** `images/imagen_service.py`, `images/imagen_controller.py`

---

## Veo (Videos)

- **Model:** Veo 2 (or configured variant)
- **Endpoints:** `/api/videos` (create, concatenate)
- **Modes:** Text-to-video, image-to-video (R2V)
- **Reference types:** ASSET (content consistency), STYLE (style transfer)
- **Files:** `videos/veo_service.py`, `videos/veo_controller.py`

---

## Gemini (Multimodal)

- **Endpoints:** `/api/gemini` (enhance prompt, critique image)
- **Uses:**
  - **Prompt enhancement** — Improve user prompts for Imagen/Veo
  - **Multimodal critic** — Evaluate generated images
  - **Brand guideline extraction** — Parse PDF content
  - **Brand infusion** — Incorporate brand guidelines into prompts
- **Files:** `multimodal/gemini_service.py`, `multimodal/gemini_controller.py`, `multimodal/rewriters.py`

---

## Model Configuration

- `common/schema/genai_model_setup.py` — model IDs, parameters
- `generation_options` API exposes aspect ratios, styles to frontend

---

## Authentication for Vertex AI

The backend runs as a service account (Cloud Run). It uses **Application Default Credentials** (ADC) to call Vertex AI—no explicit API keys for model calls.

---

## Async and Background Work

- **Short calls** (prompt enhance, simple generation): handled in request handler
- **Long calls** (VTO, large PDF processing): offloaded to `ProcessPoolExecutor` to avoid timeout

---

## Storage of Generated Media

- Images/videos written to GCS (`GENMEDIA_BUCKET`)
- Metadata (job status, URLs, prompts) stored in PostgreSQL via `MediaRepository`
- Frontend fetches presigned URLs when needed for display

---

## Next

→ [Chapter 11: End-to-End Flows](./11-end-to-end-flows.md)
