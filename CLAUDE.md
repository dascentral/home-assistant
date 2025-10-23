# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Home Assistant configuration management repository containing automations, scripts, configurations, and templates. It does NOT contain the Home Assistant core code itself - only configuration files and utilities to manage a Home Assistant installation.

## Repository Structure

- **automations/** - Home Assistant automation YAML files (lighting, climate, security, Sonos)
- **bin/** - Executable utility scripts for backup, validation, and maintenance
- **scripts/** - Home Assistant script YAML files (Sonos control scripts)
- **configurations/** - Example configuration templates with `.example` suffix
- **templates/** - Starting point templates for creating new automations
- **docs/** - Documentation including getting started guides and best practices
- **examples/** - Example implementations

## Key Architecture Patterns

### File Organization Philosophy

1. **Automations vs Scripts**: This repository distinguishes between automations (event-driven, in `automations/`) and scripts (callable sequences, in `scripts/`). For example:

   - `automations/play_sonos_favorite.yml` - Webhook-triggered automation
   - `scripts/sonos_favorite.yml` - Reusable script called by the automation

2. **Configuration Management**: Uses Home Assistant's `!include` pattern for splitting configurations. See `configurations/configuration.yaml.example` for the canonical structure.

3. **Secrets Management**: All sensitive data should use `!secret` references pointing to `secrets.yaml` (not tracked in git). Never hardcode tokens, passwords, URLs, or coordinates.

### Sonos Integration Pattern

The repository includes a sophisticated Sonos control implementation:

- **Scripts** (`scripts/sonos_*.yml`) define reusable actions with field validation
- **Automations** (`automations/play_sonos_favorite.yml`) expose webhook endpoints
- **Parameters**: Scripts accept `speaker`, `volume`, `favorite_id`, and use defaults
- **Volume Normalization**: Converts 0-100 to 0.0-1.0 for Home Assistant's `volume_level`
- **Logging**: Uses `logbook.log` service for audit trail of media actions

## Common Development Tasks

### Validating Configuration

```bash
# Set your config directory (adjust path for your installation type)
export HA_CONFIG_DIR="/config"  # or ~/.homeassistant, or custom path

# Run validation
./bin/check_config.sh
```

This script auto-detects installation type (Docker/OS/Supervised/venv) and runs appropriate validation.

### Creating Backups

```bash
export HA_CONFIG_DIR="/config"
export BACKUP_DIR="$HOME/ha-backups"  # optional, defaults shown

./bin/backup_config.sh
```

Backups exclude databases (_.db_), logs (\*.log), and ephemeral directories (.cloud, .storage, deps, tts).

### Finding Entity IDs

```bash
export HA_URL="http://homeassistant.local:8123"
export HA_TOKEN="your_long_lived_token"

python3 bin/find_entities.py
```

### Code Formatting

The repository uses Prettier for YAML formatting (`.prettierrc` present). Run:

```bash
npx prettier --write "**/*.{yaml,yml}"
```

## Development Guidelines

### When Adding Automations

1. Start from a template in `templates/` directory
2. Use descriptive `alias` names that explain what the automation does
3. Add `description` field for complex logic or business requirements
4. Update entity IDs to match actual devices (never leave placeholder IDs)
5. Use `mode:` to control concurrent execution (single/restart/queued/parallel)
6. Test using Home Assistant UI's "Run" button and trace viewer

### When Adding Scripts

1. Define clear `fields` with descriptions, examples, and validation selectors
2. Provide sensible `default` values for optional parameters
3. Use `variables` section for computed values (e.g., volume normalization)
4. Set appropriate `mode:` (restart is common for media control)
5. Add descriptive icons using `icon:` with mdi: prefix

### YAML Conventions

- Entity IDs follow pattern: `domain.location_function` (e.g., `light.living_room_ceiling`)
- Use snake_case for all identifiers
- Indent with 2 spaces (enforced by Prettier)
- Prefer templated defaults over hardcoded values in automations
- Comment complex trigger/condition logic inline

### Security Practices

- Never commit `secrets.yaml`
- Use `!secret` references in all YAML files for sensitive data
- Store access tokens in environment variables, not in scripts
- Add new sensitive files to `.gitignore` immediately

## Home Assistant Installation Types

Scripts auto-detect but you can override with environment variables:

| Type              | Config Path                       | Detection Method                        |
| ----------------- | --------------------------------- | --------------------------------------- |
| Home Assistant OS | `/config`                         | `ha` command available                  |
| Docker            | Volume mapped                     | Container name in `HA_DOCKER_CONTAINER` |
| Supervised        | `/usr/share/hassio/homeassistant` | `ha` command available                  |
| Core (venv)       | `~/.homeassistant` or custom      | `hass` command available                |

## Webhook Pattern for Automations

The `play_sonos_favorite` automation demonstrates webhook usage:

```yaml
triggers:
  - webhook_id: unique_webhook_id_here
    trigger: webhook
    allowed_methods: [POST, PUT]
    local_only: true # Security: only accept from local network
```

Access via: `http://homeassistant.local:8123/api/webhook/unique_webhook_id_here`

## Git Workflow

- Main branch: `main`
- Commit messages should describe the "why" not the "what"
- Recent commits show pattern: descriptive action + target (e.g., "Add Sonos scripts")
- Use `/bin` not `/scripts` for executable utilities (per recent refactoring)

## References

- Main repository README: `README.md`
- Getting started guide: `docs/GETTING_STARTED.md`
- Best practices guide: `docs/BEST_PRACTICES.md` (comprehensive automation patterns)
- Per-directory READMEs in each subdirectory
