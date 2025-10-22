# Automations

This directory contains Home Assistant automation YAML files organized by category.

## Structure

Automations are organized by function:

- `lighting/` - Light control automations
- `climate/` - Temperature and climate control
- `security/` - Security and monitoring
- `notifications/` - Alert and notification automations
- `energy/` - Energy management

## Using These Automations

1. Copy the automation YAML to your Home Assistant `automations.yaml` or automation directory
2. Update entity IDs to match your devices (e.g., `light.living_room` → `light.your_light`)
3. Adjust triggers, conditions, and actions as needed
4. Reload automations in Home Assistant (Developer Tools → YAML → Automations)

## Testing

Always test new automations in a safe manner:

- Use the "Run" button in the Home Assistant UI to test manually
- Monitor the automation trace to see execution flow
- Start with notification-only actions before controlling devices

## Tips

- Use descriptive names for automations
- Add comments to complex logic
- Group related automations
- Use input_boolean helpers for easy enable/disable
- Consider using automation blueprints for reusable patterns
