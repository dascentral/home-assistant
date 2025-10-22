# Home Assistant Best Practices

A collection of best practices for managing your Home Assistant installation effectively and safely.

## Configuration Management

### 1. Use Version Control

Track your configuration with Git:

```bash
cd /config
git init
echo "secrets.yaml" >> .gitignore
echo "*.db*" >> .gitignore
echo "*.log" >> .gitignore
git add .
git commit -m "Initial configuration"
```

### 2. Split Configuration Files

Instead of one large `configuration.yaml`:

```yaml
# configuration.yaml
automation: !include automations.yaml
script: !include scripts.yaml
sensor: !include sensors.yaml
group: !include groups.yaml
```

Or use directories:

```yaml
automation: !include_dir_list automations/
script: !include_dir_named scripts/
```

### 3. Use Secrets

Never hardcode sensitive data:

```yaml
# configuration.yaml
api_key: !secret openweather_api_key

# secrets.yaml (not in version control)
openweather_api_key: abc123xyz789
```

### 4. Comment Your Code

Future you will thank present you:

```yaml
# Turn on porch light at sunset for security
# Only triggers when home mode is active
automation:
  - alias: "Porch Light at Sunset"
    trigger:
      - platform: sun
        event: sunset
```

## Naming Conventions

### Entity IDs

Use clear, consistent naming:

```yaml
# Good
light.living_room_ceiling
sensor.bedroom_temperature
switch.kitchen_coffee_maker

# Avoid
light.light_1
sensor.temp_1
switch.switch_a
```

### Automation Names

Be descriptive:

```yaml
# Good
alias: "Turn on porch light at sunset"
alias: "Notify when garage door left open"

# Avoid
alias: "automation_1"
alias: "test"
```

## Automation Design

### 1. Use Conditions Wisely

Prevent unwanted triggers:

```yaml
automation:
  - alias: "Motion lights only at night"
    trigger:
      - platform: state
        entity_id: binary_sensor.motion
        to: "on"
    condition:
      # Only run at night
      - condition: sun
        after: sunset
        before: sunrise
      # Only when not in vacation mode
      - condition: state
        entity_id: input_boolean.vacation_mode
        state: "off"
    action:
      - service: light.turn_on
        entity_id: light.hallway
```

### 2. Implement Safety Checks

Add fail-safes to prevent issues:

```yaml
automation:
  - alias: "Close garage door if left open"
    trigger:
      - platform: state
        entity_id: cover.garage_door
        to: "open"
        for:
          minutes: 30
    condition:
      # Only auto-close during reasonable hours
      - condition: time
        after: "06:00:00"
        before: "23:00:00"
    action:
      # Notify before closing
      - service: notify.mobile_app
        data:
          message: "Garage door has been open for 30 minutes. Closing now."
      - delay:
          seconds: 30
      # Then close
      - service: cover.close_cover
        entity_id: cover.garage_door
```

### 3. Use Mode for Automation Behavior

Control how automations handle multiple triggers:

```yaml
automation:
  - alias: "Motion Light"
    mode: restart # Options: single, restart, queued, parallel
    trigger:
      - platform: state
        entity_id: binary_sensor.motion
```

Modes explained:

- `single`: Don't run if already running (default)
- `restart`: Stop current run, start new one
- `queued`: Queue additional runs
- `parallel`: Allow multiple simultaneous runs

## Performance Optimization

### 1. Limit Database Size

Exclude unnecessary entities from history:

```yaml
recorder:
  purge_keep_days: 7
  exclude:
    domains:
      - automation
      - updater
    entity_globs:
      - sensor.weather_*
    entities:
      - sun.sun
```

### 2. Use Template Sensors Efficiently

Avoid excessive updates:

```yaml
sensor:
  - platform: template
    sensors:
      expensive_calculation:
        # Only update every 5 minutes, not on every state change
        value_template: "{{ states('sensor.input') | float * 2.5 }}"
        availability_template: "{{ states('sensor.input') != 'unavailable' }}"
```

### 3. Disable Unused Integrations

Remove or disable integrations you don't use to reduce load.

## Security Practices

### 1. Use Strong Authentication

- Enable MFA for all users
- Use strong passwords
- Create separate users for different people
- Use guest accounts for temporary access

### 2. Secure External Access

If exposing to internet:

- Use Nabu Casa Cloud (recommended)
- Or use a VPN (WireGuard, Tailscale)
- If port forwarding: use SSL/TLS with valid certificates
- Enable fail2ban or similar

### 3. Regular Updates

- Keep Home Assistant updated
- Update all integrations
- Update the underlying OS
- Monitor security advisories

### 4. Limit Access

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - ::1
  ip_ban_enabled: true
  login_attempts_threshold: 5
```

## Backup Strategy

### 1. Multiple Backup Types

- **Full backups**: Weekly (entire system)
- **Config backups**: Daily (configuration files only)
- **Off-site backups**: Monthly (cloud storage)

### 2. Automated Backups

Use the backup script from this repository:

```bash
# Add to cron for daily backups
0 2 * * * /path/to/scripts/backup_config.sh
```

### 3. Test Your Backups

Regularly verify backups can be restored:

- Test on a separate instance
- Document restore procedure
- Keep restore process simple

## Testing and Validation

### 1. Always Validate Before Restart

```bash
# Use the check script
./scripts/check_config.sh

# Or in Home Assistant UI
Developer Tools → Check Configuration
```

### 2. Use Automation Traces

After creating an automation:

1. Go to Settings → Automations
2. Click your automation
3. Trigger it manually
4. View the trace to verify logic

### 3. Start with Notifications

Test automation logic with notifications first:

```yaml
action:
  # Test with notification first
  - service: notify.notify
    data:
      message: "Would have turned on light here"

  # Add actual control after testing
  # - service: light.turn_on
  #   entity_id: light.living_room
```

## Resource Management

### 1. Monitor System Resources

Add system monitoring:

```yaml
sensor:
  - platform: systemmonitor
    resources:
      - type: processor_use
      - type: memory_use_percent
      - type: disk_use_percent
```

### 2. Review Logs Regularly

Check for errors and warnings:

```bash
# View logs
tail -f /config/home-assistant.log

# Or in UI: Settings → System → Logs
```

### 3. Clean Up Unused Entities

Periodically review and remove:

- Disabled automations
- Unused scripts
- Old sensors
- Disconnected devices

## Documentation

### 1. Document Your Setup

Create a personal wiki or README:

- List all devices and their locations
- Document custom automations
- Note integration configurations
- Keep troubleshooting notes

### 2. Comment Complex Logic

```yaml
automation:
  - alias: "Complex automation"
    description: |
      This automation does X when Y happens.
      It was created because of Z requirement.
      Last updated: 2024-01-15
    trigger:
      # ... rest of automation
```

## Maintenance Schedule

### Daily

- Check for critical errors in logs
- Verify automations are working

### Weekly

- Review system performance
- Check for available updates
- Backup configuration

### Monthly

- Full system backup
- Review and clean up entities
- Update documentation
- Test backup restoration

### Quarterly

- Security audit
- Performance optimization review
- Update all documentation
- Test disaster recovery plan

## Common Pitfalls to Avoid

### 1. Don't Use Delay for Everything

Instead of:

```yaml
# Bad: Using delay
action:
  - service: light.turn_on
    entity_id: light.bedroom
  - delay:
      minutes: 30
  - service: light.turn_off
    entity_id: light.bedroom
```

Use:

```yaml
# Good: Using wait_for_trigger
action:
  - service: light.turn_on
    entity_id: light.bedroom
  - wait_for_trigger:
      - platform: state
        entity_id: binary_sensor.motion
        to: "off"
        for:
          minutes: 5
    timeout:
      minutes: 30
  - service: light.turn_off
    entity_id: light.bedroom
```

### 2. Don't Ignore Error Messages

- Read and understand log errors
- Fix warnings before they become problems
- Check deprecated feature notices

### 3. Don't Over-Automate

Start simple, add complexity gradually:

- One automation at a time
- Test thoroughly before moving on
- Ensure spouse/family approval 😊

## Resources

- [Official Best Practices](https://www.home-assistant.io/docs/configuration/best_practices/)
- [Automation Best Practices](https://www.home-assistant.io/docs/automation/best_practices/)
- [Security Best Practices](https://www.home-assistant.io/docs/configuration/securing/)

---

Remember: A well-maintained Home Assistant installation is reliable, secure, and a joy to use!
