# Automation & Script Patterns

## Automations vs Scripts

- **Automations** (`config/automations/`) are event-driven. They are triggered by time, state changes, webhooks, etc.
- **Scripts** (`config/scripts/`) are callable sequences. They are reusable actions invoked by automations, the UI, or voice assistants.

## Adding an Automation

1. Start from `examples/templates/automation_template.yaml`.
2. Set `mode:` to control concurrent execution (single/restart/queued/parallel).
3. Place the file in `config/automations/` — it will be auto-discovered.

## Adding a Script

1. Define `fields` with descriptions, examples, and validation `selector`s.
2. Provide sensible `default` values for optional parameters.
3. Use `variables` for computed values (e.g., volume normalization: 0-100 → 0.0-1.0).
4. Set `mode:` (restart is common for media control).
5. Add an `icon:` with `mdi:` prefix.
6. Place the file in `config/scripts/` — it will be auto-discovered.
