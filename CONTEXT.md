# Glossary

| Term | Definition |
|------|-----------|
| **Config dir (local)** | `config/` in this repo — the authored HA configuration files (automations, scripts, `configuration.yaml`). A subset of what lives on the remote. |
| **Config dir (remote)** | `/root/config` on the HA Green device at `homeassistant.local`. Contains both authored config and HA-managed state (`secrets.yaml`, `.storage/`, databases, etc.). |
| **Deploy** | Overlay the local config dir onto the remote config dir via rsync — adds and updates files but never deletes remote-only files. |
| **HA Green** | The Home Assistant Green hardware device running HAOS. Reachable at `root@homeassistant.local`. Uses `ha core check` for validation and `ha core restart` for restarts. |
| **Pre-deploy backup** | A tar.gz snapshot of the remote config dir (excluding databases, `.storage/`, `deps/`, `tts/`) created before each deploy. Stored in `/root/ha-backups/` with 90-day retention. |
