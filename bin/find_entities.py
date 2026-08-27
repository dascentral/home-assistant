#!/usr/bin/env python3
"""
Home Assistant Entity Finder

Usage:
    python3 find_entities.py [domain]

Examples:
    python3 find_entities.py           # List all entities
    python3 find_entities.py light     # List only light entities
    python3 find_entities.py scene     # List only scene entities

Configuration:
    Set these environment variables:
    - HA_URL: Your Home Assistant URL (default: http://homeassistant.local:8123)
    - HA_TOKEN: Long-lived access token from Home Assistant
"""

import json
import os
import sys
import urllib.request
import urllib.error

HA_URL = os.environ.get("HA_URL", "http://homeassistant.local:8123")
HA_TOKEN = os.environ.get("HA_TOKEN", "")


def get_entities(domain=None):
    if not HA_TOKEN:
        print("Error: HA_TOKEN environment variable not set")
        print("Create a long-lived access token in Home Assistant:")
        print("Profile > Security > Long-Lived Access Tokens")
        sys.exit(1)

    req = urllib.request.Request(
        f"{HA_URL}/api/states",
        headers={
            "Authorization": f"Bearer {HA_TOKEN}",
            "Content-Type": "application/json",
        },
    )

    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            entities = json.loads(resp.read())
    except urllib.error.URLError as e:
        print(f"Error connecting to Home Assistant: {e}")
        print(f"URL: {HA_URL}")
        sys.exit(1)

    if domain:
        entities = [e for e in entities if e["entity_id"].startswith(f"{domain}.")]

    return entities


def display_entities(entities):
    if not entities:
        print("No entities found")
        return

    print(f"\nFound {len(entities)} entities:\n")
    print(f"{'Entity ID':<50} {'State':<15} {'Name'}")
    print("-" * 100)

    for entity in sorted(entities, key=lambda e: e["entity_id"]):
        entity_id = entity["entity_id"]
        state = entity["state"]
        name = entity.get("attributes", {}).get("friendly_name", "N/A")
        print(f"{entity_id:<50} {state:<15} {name}")

    domains = {}
    for entity in entities:
        d = entity["entity_id"].split(".")[0]
        domains[d] = domains.get(d, 0) + 1

    print(f"\n{'Domain':<20} {'Count'}")
    print("-" * 30)
    for d, count in sorted(domains.items()):
        print(f"{d:<20} {count}")


if __name__ == "__main__":
    domain = sys.argv[1] if len(sys.argv) > 1 else None
    if domain:
        print(f"Fetching {domain} entities from {HA_URL}...")
    else:
        print(f"Fetching all entities from {HA_URL}...")
    entities = get_entities(domain)
    display_entities(entities)
