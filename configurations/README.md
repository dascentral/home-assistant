# Configuration Examples

This directory contains example Home Assistant configuration files to help you set up various integrations and features.

## Files

- `configuration.yaml.example` - Main configuration file example
- `automations.yaml.example` - Automation configuration structure
- `scripts.yaml.example` - Script definitions
- `sensors.yaml.example` - Custom sensor configurations
- `groups.yaml.example` - Entity groupings
- `customize.yaml.example` - Entity customization

## Usage

1. Copy the relevant example file
2. Remove the `.example` extension
3. Place in your Home Assistant config directory
4. Customize for your setup
5. Restart Home Assistant or reload the appropriate configuration

## Important Notes

### Secrets

Never commit sensitive information like passwords or API keys. Use `secrets.yaml`:

```yaml
# In configuration.yaml
api_key: !secret my_api_key

# In secrets.yaml (not committed to git)
my_api_key: your_actual_api_key_here
```

### Splitting Configuration

For better organization, you can split configuration into multiple files:

```yaml
# In configuration.yaml
automation: !include automations.yaml
script: !include scripts.yaml
sensor: !include sensors.yaml
```

### Validation

Always validate your configuration before restarting:

- Use Developer Tools → Check Configuration in the UI
- Or run `scripts/check_config.sh`

## Common Integrations

### MQTT

```yaml
mqtt:
  broker: 192.168.1.100
  username: !secret mqtt_username
  password: !secret mqtt_password
```

### Zigbee (Zigbee2MQTT or ZHA)

```yaml
# For ZHA
zha:
  database_path: /config/zigbee.db
# For Zigbee2MQTT, use MQTT integration
```

### Weather

```yaml
weather:
  - platform: met
    name: Home Weather
```

## Tips

- Start with the default configuration and add incrementally
- Comment your configurations for future reference
- Back up before making major changes
- Use the configuration validator frequently
- Join the Home Assistant community for help

## Resources

- [Configuration.yaml Documentation](https://www.home-assistant.io/docs/configuration/)
- [Integration List](https://www.home-assistant.io/integrations/)
- [YAML Syntax Guide](https://www.home-assistant.io/docs/configuration/yaml/)
