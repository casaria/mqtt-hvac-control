# mqtt-hvac-control

MQTT-based HVAC control system — configuration, automations, and topic definitions for managing heating, ventilation, and air conditioning via MQTT.

## Overview

This repository provides a YAML-driven configuration layer for controlling HVAC equipment over MQTT. It is designed to work with any MQTT broker (Mosquitto, EMQX, etc.) and integrates cleanly with Home Assistant, Node-RED, or custom subscribers.

## Features

- Thermostat setpoint control (heating / cooling / auto)
- Fan speed and mode control
- Zone-based temperature management
- Presence-aware setback automation
- Scheduled temperature programs
- Status/telemetry topic definitions

## Repository Structure

```
mqtt-hvac-control/
├── config/
│   ├── broker.yaml          # MQTT broker connection settings
│   ├── devices.yaml         # HVAC device and zone definitions
│   └── topics.yaml          # MQTT topic map
├── automations/
│   ├── thermostat.yaml      # Thermostat set-point automations
│   ├── schedules.yaml       # Time-based temperature programs
│   ├── presence.yaml        # Occupancy / away mode logic
│   └── alerts.yaml          # Fault and threshold alerts
├── scripts/
│   ├── publish_setpoint.sh  # CLI helper: publish a setpoint
│   └── subscribe_status.sh  # CLI helper: watch status topics
├── docs/
│   └── topic_reference.md   # Full MQTT topic reference
├── .gitignore
└── README.md
```

## Quick Start

### Prerequisites

- An MQTT broker (e.g. [Mosquitto](https://mosquitto.org/))
- `mosquitto_pub` / `mosquitto_sub` CLI tools, or any MQTT client
- (Optional) Home Assistant with the MQTT integration enabled

### 1. Configure your broker

Edit `config/broker.yaml`:

```yaml
broker:
  host: 192.168.1.10   # your broker IP / hostname
  port: 1883
  username: hvac_user
  password: changeme
```

### 2. Review device and zone definitions

Edit `config/devices.yaml` to match your physical equipment.

### 3. Publish a setpoint

```bash
bash scripts/publish_setpoint.sh zone1 22.5
```

### 4. Subscribe to status

```bash
bash scripts/subscribe_status.sh
```

## MQTT Topic Conventions

| Topic | Direction | Description |
|---|---|---|
| `hvac/{zone}/setpoint/set` | → broker | Set target temperature (°C) |
| `hvac/{zone}/setpoint/state` | ← broker | Current setpoint |
| `hvac/{zone}/mode/set` | → broker | `heat` / `cool` / `auto` / `off` |
| `hvac/{zone}/mode/state` | ← broker | Current mode |
| `hvac/{zone}/fan/set` | → broker | `auto` / `low` / `medium` / `high` |
| `hvac/{zone}/fan/state` | ← broker | Current fan speed |
| `hvac/{zone}/temperature` | ← broker | Ambient temperature reading |
| `hvac/{zone}/humidity` | ← broker | Ambient humidity reading |
| `hvac/{zone}/status` | ← broker | `idle` / `heating` / `cooling` / `fault` |

See `docs/topic_reference.md` for the full topic reference.

## Home Assistant Integration

Add to your `configuration.yaml`:

```yaml
mqtt:
  climate:
    - name: "Living Room HVAC"
      unique_id: hvac_zone1
      modes: [off, heat, cool, auto]
      fan_modes: [auto, low, medium, high]
      mode_command_topic: "hvac/zone1/mode/set"
      mode_state_topic: "hvac/zone1/mode/state"
      temperature_command_topic: "hvac/zone1/setpoint/set"
      temperature_state_topic: "hvac/zone1/setpoint/state"
      current_temperature_topic: "hvac/zone1/temperature"
      fan_mode_command_topic: "hvac/zone1/fan/set"
      fan_mode_state_topic: "hvac/zone1/fan/state"
      min_temp: 16
      max_temp: 30
      temp_step: 0.5
```

## License

MIT
