# HA Conventions

## Entity IDs

Follow the pattern `domain.location_function` (e.g., `light.living_room_ceiling`).

## Secrets

- Never commit `secrets.yaml` — it's in `.gitignore`.
- Use `!secret` references in all YAML files for sensitive data.
- Store access tokens in environment variables, not in scripts.
- Add new sensitive files to `.gitignore` immediately.

## Configuration Management

Uses Home Assistant's `!include` pattern for splitting configurations. See `examples/configurations/configuration.yaml.example` for the canonical structure.

## Git Workflow

- Main branch: `main`
- Commit messages describe the "why" not the "what".
- Executable utilities go in `bin/`, not alongside HA scripts.
