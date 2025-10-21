# Templates

This directory contains reusable templates for common Home Assistant patterns.

## Available Templates

### Automations
- `automation_template.yaml` - Basic automation structure
- `notification_template.yaml` - Notification automation pattern
- `presence_template.yaml` - Presence-based automation

### Scripts
- `script_template.yaml` - Basic script structure
- `notification_script.yaml` - Notification script pattern

### Sensors
- `template_sensor.yaml` - Template sensor examples

## Using Templates

1. Copy the template file
2. Rename it descriptively
3. Fill in the TODO sections
4. Customize for your needs
5. Test thoroughly before production use

## Template Syntax

Templates use Jinja2 templating. Key concepts:

### Variables
```yaml
{{ states('sensor.temperature') }}  # Get state
{{ state_attr('climate.thermostat', 'temperature') }}  # Get attribute
```

### Filters
```yaml
{{ states('sensor.temperature') | float }}  # Convert to float
{{ states('sensor.temperature') | round(1) }}  # Round to 1 decimal
```

### Conditionals
```yaml
{% if is_state('light.bedroom', 'on') %}
  Light is on
{% else %}
  Light is off
{% endif %}
```

### Loops
```yaml
{% for state in states.light %}
  {{ state.entity_id }}: {{ state.state }}
{% endfor %}
```

## Tips

- Start with the simplest template that meets your needs
- Test templates in Developer Tools → Template before using in automations
- Add comments to explain complex logic
- Use meaningful variable names
- Keep templates readable with proper indentation

## Resources

- [Templating Documentation](https://www.home-assistant.io/docs/configuration/templating/)
- [Template Editor Tool](https://www.home-assistant.io/docs/tools/dev-tools/)
