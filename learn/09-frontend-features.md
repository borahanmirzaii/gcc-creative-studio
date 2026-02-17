# Chapter 9 — Frontend Features

## Home

- Entry point after login
- Overview / dashboard
- Links to main features (Arena, Video, VTO, Audio, Gallery)

---

## Arena

- Multi-modal creative workspace
- Image + Video generation in one view
- Uses prompt box, model selector, generation options
- Integrates with `image-state.service`, `video-state.service`

---

## Video

- Dedicated video generation (Veo)
- Text-to-video and image-to-video
- Style controls, aspect ratio

---

## VTO (Virtual Try-On)

- Uses source assets (garments, models)
- Image selector for reference
- Calls backend VTO endpoint
- Uses `vto-state.service`

---

## Audio

- Text-to-speech
- Voice selection (from backend)
- Uses `services/audio/audio.service.ts`

---

## Gallery

- **MediaGalleryComponent:** Grid of images/videos
- **MediaDetailComponent:** Single item view (`/gallery/:id`)
- Uses `gallery.service.ts` for API calls
- Search, filters, pagination

---

## Fun Templates

- Prebuilt prompt templates
- Browse and apply templates to generation flows
- Uses `media-template.model.ts`, media templates service

---

## Admin Module (Lazy)

`admin/admin.module.ts` — lazy-loaded at `/admin`:

| Route | Component | Purpose |
|-------|-----------|---------|
| Media templates | MediaTemplatesManagementComponent | CRUD templates |
| Source assets | SourceAssetsManagementComponent | CRUD garments, models |
| Users | UsersManagementComponent | User CRUD |

- **AdminAuthGuard** — admin-only access
- **AdminLayoutComponent** — sidebar, header for admin pages

---

## Common Components

| Component | Purpose |
|-----------|---------|
| BrandGuidelineDialog | Upload / select brand guideline |
| ConfirmationDialog | Confirm delete, etc. |
| CreateWorkspaceModal | Create workspace |
| FlowPromptBox | Reusable prompt input |
| ImageCropperDialog | Crop images |
| ImageSelector | Pick image from gallery |
| InviteUserModal | Invite to workspace |
| MediaLightbox | Full-screen media view |
| NotificationContainer | Toast notifications |
| SourceAssetGallery | Browse source assets |
| ToastMessage | Snackbar messages |
| WorkspaceSwitcher | Switch active workspace |

---

## State Services

- `image-state.service.ts` — image generation state
- `video-state.service.ts` — video generation state
- `vto-state.service.ts` — VTO state
- `workspace-state.service.ts` — current workspace

---

## Next

→ [Chapter 10: AI Integration](./10-ai-integration.md)
