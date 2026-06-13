#!/usr/bin/env bash
# subscribe_status.sh — Subscribe to all HVAC status and telemetry topics
#
# Usage:
#   bash scripts/subscribe_status.sh [zone_id]
#
# Examples:
#   bash scripts/subscribe_status.sh          # all zones
#   bash scripts/subscribe_status.sh zone1    # single zone

set -euo pipefail

BROKER_HOST="${MQTT_HOST:-localhost}"
BROKER_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASS="${MQTT_PASS:-}"

ZONE="${1:-+}"   # default to wildcard (all zones)

AUTH_ARGS=()
[[ -n "$MQTT_USER" ]] && AUTH_ARGS+=(-u "$MQTT_USER" -P "$MQTT_PASS")

echo "Subscribing to hvac/${ZONE}/# on ${BROKER_HOST}:${BROKER_PORT}  (Ctrl-C to stop)"
echo "─────────────────────────────────────────────────────────"

mosquitto_sub \
  -h "$BROKER_HOST" \
  -p "$BROKER_PORT" \
  "${AUTH_ARGS[@]}" \
  -t "hvac/${ZONE}/#" \
  -v \
  -F "%I  %-40t  %p"
