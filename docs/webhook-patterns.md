# Webhook Patterns

Automations can be triggered via HTTP webhook:

```yaml
triggers:
  - webhook_id: !secret my_webhook_id
    trigger: webhook
    allowed_methods: [POST, PUT]
    local_only: true
```

- Always use `local_only: true` unless external access is explicitly needed.
- Store webhook IDs in `secrets.yaml` via `!secret`.
- Access URL: `http://homeassistant.local:8123/api/webhook/<webhook_id>`
