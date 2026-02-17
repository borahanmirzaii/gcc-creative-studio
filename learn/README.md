# Creative Studio — A Mini-Book

**Learning the GCC Creative Studio Codebase**

---

## Preface

This directory is a **learning guide** for the GCC Creative Studio project. It explains the full codebase—backend, frontend, infrastructure, and AI integration—as a structured mini-book.

**Who is this for?**

- Developers new to the project
- Contributors learning the architecture
- Anyone wanting to understand how the pieces fit together

**How to read it**

- **Sequential:** Start with [01-overview](./01-overview.md) and follow the chapters.
- **Reference:** Jump to specific topics using the table of contents below.
- **Related docs:** See [../docs/](../docs/) for setup, Terraform, and Firebase guides.

---

## Table of Contents

| # | Chapter | Description |
|---|---------|-------------|
| 1 | [Overview](./01-overview.md) | System architecture, tech stack, data flow |
| 2 | [Infrastructure](./02-infrastructure.md) | Terraform, GCP services, deployment |
| 3 | [Backend Overview](./03-backend-overview.md) | FastAPI entry, routers, lifespan |
| 4 | [Backend Auth](./04-backend-auth.md) | Auth guard, JIT provisioning, Firebase vs Identity Platform |
| 5 | [Backend Features](./05-backend-features.md) | Feature modules: images, videos, galleries, workspaces, etc. |
| 6 | [Backend Patterns](./06-backend-patterns.md) | DTOs, repositories, storage, common patterns |
| 7 | [Frontend Overview](./07-frontend-overview.md) | Angular structure, routing, modules |
| 8 | [Frontend Auth](./08-frontend-auth.md) | Auth service, guards, login flow |
| 9 | [Frontend Features](./09-frontend-features.md) | Home, Arena, Video, VTO, Audio, Gallery, Admin |
| 10 | [AI Integration](./10-ai-integration.md) | Vertex AI (Imagen, Veo, Gemini), multimodal |
| 11 | [End-to-End Flows](./11-end-to-end-flows.md) | Example flows: image generation, upload |
| 12 | [Glossary & Index](./12-glossary-and-index.md) | Terms, acronyms, file index |

---

## Quick Links

- [Root README](../README.md) — Project intro and deployment
- [ docs/LOCAL_DEV_SETUP.md](../docs/LOCAL_DEV_SETUP.md) — Local development
- [docs/TERRAFORM_PLAN_EXPLAINED.md](../docs/TERRAFORM_PLAN_EXPLAINED.md) — Terraform plan
- [infra/README.md](../infra/README.md) — Infrastructure overview
