# Smart Irrigation System (Reinforcement Learning) — Flutter

A Flutter + Riverpod frontend that demonstrates an RL-driven irrigation recommendation system.

## Features
- Dashboard with zones and moisture
- RL policy (mock Q-table) -> OFF/LOW/MED/HIGH
- Forecast-aware decisions
- Responsive UI, simple animations

## Quick Start
```bash
flutter pub get
flutter run
```

## Project Structure
- `lib/core/` models, providers, RL policy
- `lib/features/` UI screens
- `assets/mock/` mock data
- `assets/policy/` Q-table

## API (Mock)
See `API.md` for example endpoints. In this demo we read from assets.

## Links to include in submission
- Figma: <ADD_YOUR_FIGMA_LINK>
- GitHub: https://github.com/<your-username>/smart-irrigation-rl
- Demo video: <ADD_YOUR_VIDEO_LINK>

## License
MIT