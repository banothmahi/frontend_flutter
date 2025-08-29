# API Documentation (Basic)

> In the demo, data is loaded from assets. If you expose a backend, use these shapes.

## `GET /api/v1/forecast/today?lat=<>&lon=<>`
**Response**
```json
{
  "location": "Kanjikode, Kerala, IN",
  "date": "2025-08-29",
  "forecast": { "rain_probability": 0.3, "evapotranspiration_mm": 4.1 }
}
```

## `GET /api/v1/soil/zones`
**Response**
```json
{
  "zones": [
    {"id":"zone-1","name":"Paddy Plot A","moisture":0.24}
  ]
}
```

## `POST /api/v1/irrigation/schedule`
**Body**
```json
{"zone_id":"zone-1","action":"LOW","minutes":10}
```
**Response**
```json
{"status":"queued","id":"job-12345"}
```