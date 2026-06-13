#!/usr/bin/env bash
# publish_setpoint.sh — Publish a temperature setpoint to a zone
#
# Usage:
#   bash scripts/publish_setpoint.sh <zone_id> <temperature>
#
# Example:
#   bash scripts/publish_setpoint.sh zone1 22.5

set -euo pipefail

BROKER_HOST="${MQTT_HOST:-localhost}"
BROKER_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASS="${MQTT_PASS:-}"

ZONE="${1:?Usage: publish_setpoint.sh <zone_id> <temperature>}"
TEMP="${2:?Usage: publish_setpoint.sh <zone_id> <temperature>}"

AUTH_ARGS=()
[[ -n "$MQTT_USER" ]] && AUTH_ARGS+=(-u "$MQTT_USER" -P "$MQTT_PASS")

TOPIC="hvac/${ZONE}/setpoint/set"

echo "→ Publishing setpoint ${TEMP}°C to ${TOPIC} on ${BROKER_HOST}:${BROKER_PORT}"

mosquitto_pub \
  -h "$BROKER_HOST" \
  -p "$BROKER_PORT" \
  "${AUTH_ARGS[@]}" \
  -t "$TOPIC" \
  -m "$TEMP" \
  -q 1 \
  -r

echo "✓ Done"
