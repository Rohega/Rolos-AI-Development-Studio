# API Design Standards

## REST Conventions

- Nouns for resources, HTTP verbs for actions
- Plural resource names: `/api/v1/invoices`
- Nested resources max 2 levels deep
- Use query params for filtering, sorting, pagination

## Request / Response

- JSON only unless ADR specifies otherwise
- Consistent envelope or bare resources per project ADR — pick one and stick to it
- ISO 8601 timestamps in UTC
- Errors: `{ "error": { "code": "...", "message": "...", "details": [] } }`

## Versioning

- URL path versioning: `/api/v1/`
- Breaking changes require new version; deprecate old with timeline

## Pagination

- Cursor-based for large datasets; offset acceptable for admin UIs
- Include `meta` with total count when inexpensive

## Authentication

- Token or session per ADR
- Rate limiting on public endpoints

## Documentation

- Every endpoint documented with method, path, params, response schema, error codes
- OpenAPI/Swagger when API is external-facing

## References

- Skill: `create-api-endpoints`
- Standard: `.ai/standards/security.md`
