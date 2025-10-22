#!/bin/bash

#############################################
# Home Assistant Configuration Backup Script
# 
# This script creates a timestamped backup of
# your Home Assistant configuration directory
#############################################

# Configuration
HA_CONFIG_DIR="${HA_CONFIG_DIR:-/config}"  # Default Home Assistant config directory
BACKUP_DIR="${BACKUP_DIR:-$HOME/ha-backups}"  # Where to store backups
BACKUP_RETENTION_DAYS=30  # Keep backups for 30 days

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if config directory exists
if [ ! -d "$HA_CONFIG_DIR" ]; then
    log_error "Home Assistant config directory not found: $HA_CONFIG_DIR"
    log_info "Set HA_CONFIG_DIR environment variable to your config directory"
    exit 1
fi

# Generate backup filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/ha_config_backup_$TIMESTAMP.tar.gz"

log_info "Starting backup of Home Assistant configuration..."
log_info "Source: $HA_CONFIG_DIR"
log_info "Destination: $BACKUP_FILE"

# Create the backup (excluding certain directories and files)
tar -czf "$BACKUP_FILE" \
    -C "$(dirname "$HA_CONFIG_DIR")" \
    --exclude="*.db" \
    --exclude="*.db-wal" \
    --exclude="*.db-shm" \
    --exclude="*.log" \
    --exclude=".cloud" \
    --exclude=".storage" \
    --exclude="deps" \
    --exclude="tts" \
    --exclude="*.pyc" \
    "$(basename "$HA_CONFIG_DIR")" 2>&1

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log_info "Backup completed successfully!"
    log_info "Backup size: $BACKUP_SIZE"
    log_info "Backup location: $BACKUP_FILE"
else
    log_error "Backup failed!"
    exit 1
fi

# Clean up old backups
log_info "Cleaning up backups older than $BACKUP_RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "ha_config_backup_*.tar.gz" -mtime +$BACKUP_RETENTION_DAYS -delete
REMAINING_BACKUPS=$(find "$BACKUP_DIR" -name "ha_config_backup_*.tar.gz" | wc -l)
log_info "Total backups retained: $REMAINING_BACKUPS"

log_info "Backup process complete!"
