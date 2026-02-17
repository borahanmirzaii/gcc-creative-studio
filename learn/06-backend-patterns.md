# Chapter 6 — Backend Patterns

## DTOs (Data Transfer Objects)

- **Request DTOs:** Validate incoming JSON (Pydantic).
- **Response DTOs:** Shape outgoing JSON; often use `alias_generator=to_camel` for camelCase.
- **Location:** Each feature has a `dto/` subfolder (e.g. `images/dto/create_imagen_dto.py`).

---

## Base DTO

`common/base_dto.py` defines shared enums and base types:

- `AspectRatioEnum`, `GenerationModelEnum`, `MimeTypeEnum`
- Used across images, videos, and galleries

---

## Repository Pattern

`BaseRepository` in `common/base_repository.py` provides generic CRUD:

- `get_by_id`, `create`, `update`, `delete`
- `list` with pagination, filters
- Generic over SQLAlchemy model and Pydantic schema

```python
# Example
class UserRepository(BaseRepository[User, UserModel]):
    def __init__(self, db: AsyncSession):
        super().__init__(User, UserModel, db)
```

Feature repositories extend `BaseRepository` and add domain-specific methods.

---

## Storage Service

`common/storage_service.py` — `GcsService`:

- `upload_file`, `download_from_gcs`, `download_bytes_from_gcs`
- `generate_signed_url` — for presigned upload/download
- Uses `GENMEDIA_BUCKET` from config

---

## Schemas vs DTOs

- **Schema:** DB model (SQLAlchemy) or internal Pydantic model for ORM mapping.
- **DTO:** API boundary (request/response).
- Feature folders often have `schema/` for DB models and `dto/` for API shapes.

---

## Background Processing

Long-running work (VTO, brand guideline PDF processing) runs in **separate processes** via `ProcessPoolExecutor`:

- Avoids blocking the main FastAPI process
- Worker imports its own services (no shared state)
- Cloud Logging in production for worker logs

---

## Config Service

`config/config_service.py` loads environment variables:

- `ENVIRONMENT`, `PROJECT_ID`, `GENMEDIA_BUCKET`
- `GOOGLE_TOKEN_AUDIENCE`, `IDENTITY_PLATFORM_ALLOWED_ORGS`
- `FRONTEND_URL`, `LOG_LEVEL`

Accessed as singleton `config_service`.

---

## Dependency Injection

FastAPI's `Depends()` is used for:

- `get_current_user` → `UserModel`
- `UserService`, repositories (injected with `AsyncSession`)
- `RoleChecker` for role-based access

---

## Next

→ [Chapter 7: Frontend Overview](./07-frontend-overview.md)
