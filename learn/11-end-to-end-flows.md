# Chapter 11 — End-to-End Flows

## Flow 1: Image Generation

1. User enters prompt in Arena or Image view
2. (Optional) Frontend calls `/api/gemini/enhance-prompt` to improve prompt
3. Frontend calls `POST /api/images` with prompt, options
4. Backend: `ImagenService` → Vertex AI Imagen → stores image in GCS
5. Backend saves media item in PostgreSQL
6. Returns media item (ID, GCS path, status)
7. Frontend polls or receives status, displays image via presigned URL

---

## Flow 2: Brand Guideline Upload

1. User opens Brand Guideline dialog
2. Frontend calls `POST /api/brand-guidelines/generate-upload-url` with filename, size
3. Backend returns presigned GCS URL (PUT)
4. Frontend uploads PDF directly to GCS (no backend proxy)
5. Frontend calls `POST /api/brand-guidelines/finalize-upload` with GCS path
6. Backend enqueues background job:
   - Download PDF from GCS
   - Split if > 50MB (Gemini limit)
   - Extract text/structure with Gemini
   - Store guideline metadata in PostgreSQL
7. Frontend can later use guideline when generating (brand infusion in prompts)

---

## Flow 3: Video Generation (Image-to-Video)

1. User selects reference image (ASSET or STYLE)
2. User enters prompt
3. (Optional) Prompt enhancement via Gemini
4. Frontend calls `POST /api/videos` with prompt, reference image URI, reference type
5. Backend: `VeoService` → Vertex AI Veo
6. Video stored in GCS, metadata in PostgreSQL
7. Frontend displays result

---

## Flow 4: Login and First Request

1. User clicks "Sign in with Google"
2. Firebase/Identity Platform completes OAuth
3. Frontend obtains ID token, stores in auth state
4. User navigates to protected route (e.g. `/arena`)
5. `AuthGuardService` allows (token present)
6. Component loads, calls API (e.g. list templates)
7. `auth.interceptor` adds `Authorization: Bearer <token>`
8. Backend `get_current_user` verifies token, JIT-provisions user
9. Request proceeds with `UserModel` in context

---

## Flow 5: VTO (Virtual Try-On)

1. User selects garment and model (or uploads)
2. User selects/submits reference image
3. Frontend calls `POST /api/images/vto` with inputs
4. Backend starts **background process** (ProcessPoolExecutor)
5. Returns job ID immediately
6. Frontend polls for status
7. Worker: runs VTO pipeline, saves result to GCS, updates DB
8. Frontend displays result when ready

---

## Next

→ [Chapter 12: Glossary & Index](./12-glossary-and-index.md)
