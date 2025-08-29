# Architecture / Flow

Flutter UI (Riverpod) -> Data providers
- `forecastProvider`: loads weather forecast
- `zonesProvider`: loads soil moisture per zone
- `policyProvider`: loads RL Q-table

Decision Flow
1. Read soil moisture of selected zone
2. Read rain probability from forecast
3. Compute bins and select best action from Q-table
4. Show recommendation and allow user to "Apply" (mock send)