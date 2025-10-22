#!/usr/bin/env python3
"""
Home Assistant Entity Finder

This script connects to your Home Assistant instance and lists all entities,
optionally filtered by domain (e.g., light, switch, sensor).

Usage:
    python find_entities.py [domain]
    
Examples:
    python find_entities.py           # List all entities
    python find_entities.py light     # List only light entities
    python find_entities.py sensor    # List only sensor entities

Requirements:
    - Python 3.7+
    - requests library (pip install requests)
    - Home Assistant long-lived access token

Configuration:
    Set these environment variables:
    - HA_URL: Your Home Assistant URL (e.g., http://homeassistant.local:8123)
    - HA_TOKEN: Long-lived access token from Home Assistant
"""

import os
import sys
import requests
from typing import List, Dict, Optional

# Configuration
HA_URL = os.environ.get('HA_URL', 'http://homeassistant.local:8123')
HA_TOKEN = os.environ.get('HA_TOKEN', '')

def get_entities(domain: Optional[str] = None) -> List[Dict]:
    """
    Fetch entities from Home Assistant
    
    Args:
        domain: Optional domain filter (e.g., 'light', 'switch')
    
    Returns:
        List of entity dictionaries
    """
    if not HA_TOKEN:
        print("Error: HA_TOKEN environment variable not set")
        print("Create a long-lived access token in Home Assistant:")
        print("Profile → Security → Long-Lived Access Tokens")
        sys.exit(1)
    
    headers = {
        'Authorization': f'Bearer {HA_TOKEN}',
        'Content-Type': 'application/json'
    }
    
    try:
        response = requests.get(f'{HA_URL}/api/states', headers=headers, timeout=10)
        response.raise_for_status()
        
        entities = response.json()
        
        # Filter by domain if specified
        if domain:
            entities = [e for e in entities if e['entity_id'].startswith(f'{domain}.')]
        
        return entities
    
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to Home Assistant: {e}")
        print(f"URL: {HA_URL}")
        print("Check that:")
        print("  1. Home Assistant is running")
        print("  2. HA_URL is correct")
        print("  3. HA_TOKEN is valid")
        sys.exit(1)

def display_entities(entities: List[Dict]):
    """Display entities in a formatted manner"""
    if not entities:
        print("No entities found")
        return
    
    print(f"\nFound {len(entities)} entities:\n")
    print(f"{'Entity ID':<50} {'State':<15} {'Name'}")
    print("-" * 100)
    
    for entity in sorted(entities, key=lambda e: e['entity_id']):
        entity_id = entity['entity_id']
        state = entity['state']
        name = entity.get('attributes', {}).get('friendly_name', 'N/A')
        print(f"{entity_id:<50} {state:<15} {name}")
    
    # Domain summary
    domains = {}
    for entity in entities:
        domain = entity['entity_id'].split('.')[0]
        domains[domain] = domains.get(domain, 0) + 1
    
    print(f"\n{'Domain':<20} {'Count'}")
    print("-" * 30)
    for domain, count in sorted(domains.items()):
        print(f"{domain:<20} {count}")

def main():
    """Main function"""
    domain = sys.argv[1] if len(sys.argv) > 1 else None
    
    if domain:
        print(f"Fetching {domain} entities from {HA_URL}...")
    else:
        print(f"Fetching all entities from {HA_URL}...")
    
    entities = get_entities(domain)
    display_entities(entities)

if __name__ == '__main__':
    main()
