# MQTT Topic Reference

Full reference for all topics used by mqtt-hvac-control.  
Replace `{zone}` with the zone id (e.g. `zone1`, `zone2`, `zone3`).

---

## Control Topics (publish to these)

| Topic | Payload | QoS | Retain | Description |
|---|---|---|---|---|
| `hvac/{zone}/setpoint/set` | float, e.g. `22.5` | 1 | yes | Target temperature in °C |
| `hvac/{zone}/mode/set` | `heat` \| `cool` \| `auto` \| `dry` \| `off` | 1 | yes | Operating mode |
| `hvac/{zone}/fan/set` | `auto` \| `low` \| `medium` \| `high` | 1 | yes | Fan speed |
| `hvac/{zone}/swing/set` | `on` \| `off` | 1 | yes | Louvre swing |
| `hvac/{zone}/power/set` | `on` \| `off` | 1 | yes | Hard power toggle |
| `hvac/system/reset` | `RESET` | 1 | no | Reset all zones to defaults |

---

## State Topics (subscribe to these)

| Topic | Payload | Retained | Description |
|---|---|---|---|
| `hvac/{zone}/setpoint/state` | float | yes | Current setpoint |
| `hvac/{zone}/mode/state` | string | yes | Active mode |
| `hvac/{zone}/fan/state` | string | yes | Active fan speed |
| `hvac/{zone}/swing/state` | `on` \| `off` | yes | Active swing state |
| `hvac/{zone}/power/state` | `on` \| `off` | yes | Power state |

---

## Telemetry Topics

| Topic | Payload | Frequency | Description |
|---|---|---|---|
| `hvac/{zone}/temperature` | float (°C) | ~60 s | Ambient temperature |
| `hvac/{zone}/humidity` | float (%RH) | ~60 s | Relative humidity |
| `hvac/{zone}/status` | `idle` \| `heating` \| `cooling` \| `dry` \| `fault` | on-change | Operating status |
| `hvac/{zone}/energy` | float (kWh) | ~300 s | Cumulative energy |
| `hvac/{zone}/availability` | `online` \| `offline` | LWT / on-change | Controller availability |
| `hvac/{zone}/diagnostics` | JSON | on-request | Raw diagnostic payload |

---

## Diagnostics JSON Schema

```json
{
  "zone": "zone1",
  "firmware": "1.2.3",
  "uptime_s": 86400,
  "rssi_dbm": -55,
  "error_code": 0,
  "last_error": null
}
```

---

## Wildcard Subscriptions

| Pattern | Matches |
|---|---|
| `hvac/+/temperature` | Temperature for every zone |
| `hvac/+/status` | Status for every zone |
| `hvac/#` | Everything |
| `hvac/zone1/#` | All topics for zone1 |
