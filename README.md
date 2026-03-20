# Thermodynamic Engine Cycle Simulator

MATLAB simulation of Otto, Diesel, and Dual thermodynamic cycles. Calculates state point values, plots P-V diagrams, and animates the full 5-stroke piston cycle.

---

## Files

```
main_engine.m        ← run this for command-line use
engine_gui.m         ← simple GUI with buttons for each cycle
otto_engine.m        ← Otto cycle calculations
diesel_engine.m      ← Diesel cycle calculations
dual_engine.m        ← Dual cycle calculations
plot_cycle.m         ← draws the P-V diagram
pidton_animation.m   ← piston animation (5 strokes)
```

---

## How to Run

**Command line:**
```matlab
>> main_engine
```
Prompts you to pick a cycle and enter parameters one by one.

**GUI:**
```matlab
>> engine_gui
```
Opens a small window — just click the cycle you want.

**Animation only:**
```matlab
>> pidton_animation
```
Type `otto`, `diesel`, or `dual` when asked.

---

## Parameters

### Otto — `otto_engine(P1, T1, V1, r, T3, gamma)`

| Input | What it is |
|-------|------------|
| `P1` | Initial pressure (Pa) |
| `T1` | Initial temperature (K) |
| `V1` | Initial volume (m³) |
| `r` | Compression ratio |
| `T3` | Peak temperature (K) |
| `gamma` | Specific heat ratio |

### Diesel — `diesel_engine(P1, T1, V1, r, rc, gamma)`

Same as Otto, plus `rc` = cutoff ratio (V₃/V₂).

### Dual — `dual_engine(P1, T1, V1, r, rc, rp, gamma)`

Same as Diesel, plus `rp` = pressure ratio (P₃/P₂).

---

## Output

All three functions return the same struct:

```matlab
result.P            % pressure at each state point (Pa)
result.T            % temperature at each state point (K)
result.V            % volume at each state point (m³)
result.Work         % net work output (J)
result.Efficiency   % thermal efficiency (0–1)
```

---

## Quick Example

```matlab
P1 = 101325;  T1 = 300;  V1 = 0.0005;
r = 8;  T3 = 2000;  gamma = 1.4;

result = otto_engine(P1, T1, V1, r, T3, gamma);
fprintf('Work: %.1f J,  Eta: %.1f%%\n', result.Work, result.Efficiency*100);

plot_cycle(result, 1);
```

---

## Animation — 5 Strokes

| Stroke | Piston | Valves |
|--------|--------|--------|
| 1 — Intake | TDC → BDC | IN open |
| 2 — Compression | BDC → TDC | both closed |
| 3 — Heat addition | depends on cycle | both closed |
| 4 — Expansion | cutoff point → BDC | both closed |
| 5 — Exhaust | BDC → TDC | EX open |

Heat addition differences:

- **Otto** — piston stays at TDC (constant volume)
- **Diesel** — piston moves down as fuel burns (constant pressure)
- **Dual** — stationary first, then moves down (CV then CP)

---

## Assumptions

- Ideal gas throughout
- cᵥ = 718 J/kg·K, cₚ = γ · cᵥ
- Isentropic compression and expansion (no heat loss)
- No friction, no blow-by

---

## Requirements

MATLAB R2018b or newer. No extra toolboxes needed.
