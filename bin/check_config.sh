#!/bin/bash

################################################
# Home Assistant Configuration Validation Script
# 
# Validates your Home Assistant configuration
# before restarting the service
################################################

# Configuration
HA_CONFIG_DIR="${HA_CONFIG_DIR:-/config}"
HA_DOCKER_CONTAINER="${HA_DOCKER_CONTAINER:-homeassistant}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_info "Checking Home Assistant configuration..."

# Check if running in Docker
if command -v docker &> /dev/null && docker ps | grep -q "$HA_DOCKER_CONTAINER"; then
    log_info "Detected Home Assistant running in Docker"
    log_info "Running configuration check in container..."
    
    docker exec "$HA_DOCKER_CONTAINER" python -m homeassistant --config "$HA_CONFIG_DIR" --script check_config
    
    if [ $? -eq 0 ]; then
        log_info "✓ Configuration is valid!"
        exit 0
    else
        log_error "✗ Configuration validation failed!"
        log_error "Please review the errors above and fix your configuration"
        exit 1
    fi

# Check if hass command is available (Home Assistant OS / Supervised)
elif command -v ha &> /dev/null; then
    log_info "Using Home Assistant CLI (ha command)"
    ha core check
    
    if [ $? -eq 0 ]; then
        log_info "✓ Configuration is valid!"
        exit 0
    else
        log_error "✗ Configuration validation failed!"
        exit 1
    fi

# Try direct Python invocation (for venv installations)
elif [ -d "$HA_CONFIG_DIR" ]; then
    log_info "Attempting direct configuration check..."
    
    # Try to find Home Assistant Python installation
    if command -v hass &> /dev/null; then
        hass --config "$HA_CONFIG_DIR" --script check_config
        
        if [ $? -eq 0 ]; then
            log_info "✓ Configuration is valid!"
            exit 0
        else
            log_error "✗ Configuration validation failed!"
            exit 1
        fi
    else
        log_error "Could not find Home Assistant installation"
        log_info "This script supports:"
        log_info "  - Docker installations (set HA_DOCKER_CONTAINER)"
        log_info "  - Home Assistant OS / Supervised (uses 'ha' command)"
        log_info "  - Virtual environment installations (uses 'hass' command)"
        exit 1
    fi
else
    log_error "Configuration directory not found: $HA_CONFIG_DIR"
    log_info "Set HA_CONFIG_DIR environment variable to your config directory"
    exit 1
fi
