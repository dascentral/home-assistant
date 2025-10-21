# Getting Started with This Repository

Welcome! This guide will help you start using this Home Assistant management repository.

## Prerequisites

Before you begin, ensure you have:

1. **Home Assistant Installed** - Running on any supported platform:
   - Home Assistant OS (Recommended for beginners)
   - Home Assistant Container (Docker)
   - Home Assistant Supervised
   - Home Assistant Core (Python virtual environment)

2. **Basic Knowledge**:
   - YAML syntax fundamentals
   - Basic Linux/command line operations
   - Understanding of your Home Assistant installation location

3. **Access**:
   - SSH or direct access to your Home Assistant host
   - Admin access to Home Assistant web interface

## Quick Start

### 1. Clone This Repository

```bash
# Clone to your local machine
git clone https://github.com/dascentral/home-assistant.git
cd home-assistant
```

### 2. Review Available Resources

Explore the directory structure:
```bash
ls -la
```

You'll find:
- `automations/` - Ready-to-use automation examples
- `scripts/` - Utility scripts for management
- `configurations/` - Configuration file templates
- `docs/` - Documentation (you are here!)

### 3. Set Up Your First Automation

Let's add a simple automation:

1. Navigate to `automations/` directory
2. Open `lighting_sunset.yaml`
3. Copy its content
4. In Home Assistant, go to Settings → Automations & Scenes
5. Click "Create Automation" → "Skip" → Switch to YAML mode
6. Paste the automation
7. Update entity IDs to match your devices
8. Save and test!

### 4. Use a Utility Script

Try the backup script:

```bash
# Make it executable
chmod +x scripts/backup_config.sh

# Set your config directory (adjust path as needed)
export HA_CONFIG_DIR="/config"  # or your actual path

# Run the backup
./scripts/backup_config.sh
```

## Understanding Home Assistant Paths

Your configuration location depends on your installation method:

| Installation Type | Config Path |
|------------------|-------------|
| Home Assistant OS | `/config` |
| Docker | Mapped volume (e.g., `/path/to/config`) |
| Supervised | `/usr/share/hassio/homeassistant` |
| Core (venv) | `~/.homeassistant` or custom |

## Common First Tasks

### Task 1: Create Your First Backup

```bash
cd scripts
export HA_CONFIG_DIR="/config"  # Update this
./backup_config.sh
```

### Task 2: List All Your Entities

```bash
cd scripts
export HA_URL="http://homeassistant.local:8123"
export HA_TOKEN="your_long_lived_token"
python3 find_entities.py
```

To get a token:
1. In Home Assistant: Profile → Security
2. Scroll to "Long-Lived Access Tokens"
3. Click "Create Token"
4. Copy the token (save it securely!)

### Task 3: Add a Motion-Activated Light

1. Open `automations/motion_detection.yaml`
2. Review the automation logic
3. Update these entity IDs:
   - `binary_sensor.hallway_motion` → your motion sensor
   - `light.hallway` → your light entity
4. Copy to your Home Assistant automations
5. Test the automation

### Task 4: Set Up Climate Control

1. Review `automations/climate_control.yaml`
2. Update entity IDs for your thermostat
3. Adjust temperature values for your preference
4. Consider your schedule (work, sleep times)
5. Add to Home Assistant and monitor behavior

## Best Practices

### 1. Always Backup Before Changes
```bash
./scripts/backup_config.sh
```

### 2. Validate Configuration
Before restarting Home Assistant, check your config:
```bash
./scripts/check_config.sh
```

Or in the UI: Developer Tools → Check Configuration

### 3. Test in Safe Mode
- Use the automation trace feature to debug
- Start with notification-only actions
- Gradually add control actions once verified

### 4. Version Control
Consider tracking your actual Home Assistant config with Git:
```bash
cd /config
git init
git add .
git commit -m "Initial configuration"
```

### 5. Use Secrets
Never commit passwords or tokens:
```yaml
# configuration.yaml
api_key: !secret my_api_key

# secrets.yaml (add to .gitignore)
my_api_key: abc123xyz
```

## Troubleshooting

### Issue: Scripts won't run
**Solution**: Make them executable
```bash
chmod +x scripts/*.sh
```

### Issue: Can't find entities
**Solution**: Use the entity finder
```bash
export HA_URL="http://your-ha-url:8123"
export HA_TOKEN="your-token"
python3 scripts/find_entities.py
```

### Issue: Automation not triggering
**Solutions**:
1. Check automation is enabled in UI
2. Review conditions (might be preventing execution)
3. Use Developer Tools → Events to watch for triggers
4. Check Home Assistant logs

### Issue: Configuration validation fails
**Solutions**:
1. Check YAML syntax (indentation matters!)
2. Verify entity IDs exist
3. Review Home Assistant logs for specific errors
4. Use a YAML validator online

## Next Steps

Once you're comfortable with the basics:

1. **Customize Existing Automations** - Adapt examples to your needs
2. **Create New Automations** - Use templates as starting points
3. **Explore Advanced Features**:
   - Node-RED for complex automations
   - AppDaemon for Python-based automation
   - Custom integrations
4. **Join the Community**:
   - [Home Assistant Community Forums](https://community.home-assistant.io/)
   - [Home Assistant Discord](https://discord.gg/home-assistant)
   - [Reddit r/homeassistant](https://reddit.com/r/homeassistant)

## Getting Help

If you encounter issues:

1. Check the `docs/` directory for specific guides
2. Review Home Assistant logs (Settings → System → Logs)
3. Search the Home Assistant Community Forums
4. Open an issue in this repository for repository-specific problems

## Resources

- [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- [Automation Documentation](https://www.home-assistant.io/docs/automation/)
- [Templating Guide](https://www.home-assistant.io/docs/configuration/templating/)
- [YAML Configuration](https://www.home-assistant.io/docs/configuration/yaml/)

---

Happy Automating! 🏠✨
