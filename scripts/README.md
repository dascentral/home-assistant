# Scripts

Utility scripts for managing and maintaining your Home Assistant installation.

## Available Scripts

### Backup Scripts
- `backup_config.sh` - Creates a backup of your Home Assistant configuration
- `restore_config.sh` - Restores configuration from backup

### Maintenance Scripts
- `check_config.sh` - Validates Home Assistant configuration
- `update_ha.sh` - Helper script for updating Home Assistant
- `cleanup_logs.sh` - Cleans up old log files

### Utility Scripts
- `find_entities.py` - Lists all entities in your Home Assistant instance
- `check_updates.py` - Checks for available updates for integrations

## Usage

### Prerequisites

Most scripts require:
- Bash shell (Linux/macOS) or WSL (Windows)
- Home Assistant running and accessible
- Appropriate permissions on the Home Assistant config directory

### Running Scripts

Make scripts executable:
```bash
chmod +x script_name.sh
```

Run a script:
```bash
./script_name.sh
```

For Python scripts:
```bash
python3 script_name.py
```

## Configuration

Some scripts require configuration. Edit the variables at the top of each script:
- `HA_CONFIG_DIR` - Path to Home Assistant config directory
- `BACKUP_DIR` - Path where backups should be stored
- `HA_URL` - Home Assistant instance URL
- `HA_TOKEN` - Long-lived access token (store securely!)

## Security Notes

- Never commit access tokens or passwords to version control
- Use environment variables or a separate config file for sensitive data
- Limit script permissions to only what's necessary
- Review scripts before running them on production systems

## Contributing

When adding new scripts:
- Include a descriptive header comment
- Document all configuration variables
- Add usage examples
- Test thoroughly before committing
