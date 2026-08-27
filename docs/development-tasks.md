# Development Tasks

## Validating Configuration

```bash
export HA_CONFIG_DIR="/config"  # adjust for your installation type
./bin/check_config.sh
```

Auto-detects installation type (Docker/OS/Supervised/venv).

## Creating Backups

```bash
export HA_CONFIG_DIR="/config"
export BACKUP_DIR="$HOME/ha-backups"  # optional
./bin/backup_config.sh
```

Excludes databases, logs, and ephemeral directories (.cloud, .storage, deps, tts).

## Finding Entity IDs

```bash
export HA_URL="http://homeassistant.local:8123"
export HA_TOKEN="your_long_lived_token"
python3 bin/find_entities.py
```
