# CLAUDE.md

Personal Home Assistant configuration repo that includes YAML automations, scripts, and utilities for managing a Home Assistant installation. This is NOT HA core; it's config files only.

## Repo Layout

- **config/** — HA source of truth: `config/automations/`, `config/scripts/`, `config/configuration.yaml`
- **bin/** — Executable utilities (backup, validation, entity discovery)
- **examples/** — Reference material: sample automations, config templates (`.example`), and scaffolding templates
- **docs/** — Guides (getting started, best practices)

## Key Rules

- All sensitive data uses `!secret` references → `secrets.yaml` (never committed). Never hardcode tokens, passwords, URLs, or coordinates.
- Config uses `!include_dir_merge_list` (automations) and `!include_dir_merge_named` (scripts) to auto-discover YAML files in their directories.
- Format with Prettier: `npx prettier --write "**/*.{yaml,yml}"`

## Detailed Guidance

- [HA Conventions](docs/ha-conventions.md) — entity IDs, secrets, YAML patterns
- [Development Tasks](docs/development-tasks.md) — validation, backup, entity discovery
- [Automation & Script Patterns](docs/automation-and-script-patterns.md) — how to add new automations and scripts
- [Webhook Patterns](docs/webhook-patterns.md) — webhook-triggered automation pattern
- [Getting Started](docs/getting-started.md) — setup guide for new users of this repo
- [Best Practices](docs/best-practices.md) — HA configuration, security, and maintenance patterns

## Agent skills

### Issue tracker

GitHub Issues (via `gh` CLI). See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout: `CONTEXT.md` at root + `docs/adr/`. See `docs/agents/domain.md`.
