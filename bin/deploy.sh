#!/bin/bash

HA_HOST="${HA_HOST:-homeassistant.local}"
HA_USER="${HA_USER:-root}"
HA_CONFIG_DIR="${HA_CONFIG_DIR:-/root/config}"
BACKUP_DIR="/root/ha-backups"
BACKUP_RETENTION_DAYS=90

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCAL_CONFIG="$REPO_DIR/config/"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

DRY_RUN=false
RESTART=false

usage() {
    echo "Usage: $(basename "$0") [--dry-run] [--restart]"
    echo
    echo "Deploy config/ to Home Assistant at ${HA_USER}@${HA_HOST}:${HA_CONFIG_DIR}"
    echo
    echo "Options:"
    echo "  --dry-run   Show what rsync would transfer without making changes"
    echo "  --restart   Restart Home Assistant after a successful deploy"
    echo "  -h, --help  Show this help message"
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --dry-run)  DRY_RUN=true ;;
        --restart)  RESTART=true ;;
        -h|--help)  usage ;;
        *)          log_error "Unknown option: $arg"; usage ;;
    esac
done

if [ ! -d "$LOCAL_CONFIG" ]; then
    log_error "Local config directory not found: $LOCAL_CONFIG"
    exit 1
fi

log_info "Checking SSH connectivity to ${HA_USER}@${HA_HOST}..."
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "${HA_USER}@${HA_HOST}" 'true' 2>/dev/null; then
    log_error "Cannot connect to ${HA_USER}@${HA_HOST}"
    log_error "Ensure SSH key auth is configured and the device is reachable"
    exit 1
fi
log_info "SSH connection OK"

if [ "$DRY_RUN" = true ]; then
    log_info "Dry run — showing what would be transferred:"
    rsync -avz --dry-run \
        --exclude 'secrets.yaml' \
        --exclude '.DS_Store' \
        --exclude '*.pyc' \
        --exclude '__pycache__/' \
        "$LOCAL_CONFIG" "${HA_USER}@${HA_HOST}:${HA_CONFIG_DIR}/"
    exit 0
fi

log_info "Creating pre-deploy backup on remote..."
ssh "${HA_USER}@${HA_HOST}" "
    mkdir -p ${BACKUP_DIR}
    tar czf ${BACKUP_DIR}/pre-deploy-\$(date +%Y%m%d_%H%M%S).tar.gz \
        -C $(dirname "$HA_CONFIG_DIR") \
        --exclude='*.db' \
        --exclude='*.db-wal' \
        --exclude='*.db-shm' \
        --exclude='.storage' \
        --exclude='deps' \
        --exclude='tts' \
        $(basename "$HA_CONFIG_DIR")
"
if [ $? -ne 0 ]; then
    log_error "Pre-deploy backup failed — aborting"
    exit 1
fi
log_info "Backup complete"

log_info "Cleaning up backups older than ${BACKUP_RETENTION_DAYS} days..."
ssh "${HA_USER}@${HA_HOST}" "find ${BACKUP_DIR} -name 'pre-deploy-*.tar.gz' -mtime +${BACKUP_RETENTION_DAYS} -delete"

log_info "Deploying config/ to ${HA_USER}@${HA_HOST}:${HA_CONFIG_DIR}/"
rsync -avz \
    --exclude 'secrets.yaml' \
    --exclude '.DS_Store' \
    --exclude '*.pyc' \
    --exclude '__pycache__/' \
    "$LOCAL_CONFIG" "${HA_USER}@${HA_HOST}:${HA_CONFIG_DIR}/"

if [ $? -ne 0 ]; then
    log_error "rsync failed"
    exit 1
fi
log_info "Files deployed successfully"

log_info "Validating configuration on remote..."
if ! ssh "${HA_USER}@${HA_HOST}" 'ha core check'; then
    log_error "Configuration validation failed!"
    log_error "Files are on the remote but HA cannot load them"
    if [ "$RESTART" = true ]; then
        log_warn "Skipping restart due to config errors — fix and re-deploy"
    fi
    exit 1
fi
log_info "Configuration is valid"

if [ "$RESTART" = true ]; then
    log_info "Restarting Home Assistant..."
    ssh "${HA_USER}@${HA_HOST}" 'ha core restart'
    if [ $? -ne 0 ]; then
        log_error "Restart command failed"
        exit 1
    fi
    log_info "Home Assistant is restarting"
else
    log_info "Deploy complete — restart HA manually when ready"
fi
