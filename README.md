# Thermodynamic Engine Cycle Simulator

MATLAB simulation of Otto, Diesel, Dual, and Rankine thermodynamic cycles. Calculates state point values, plots P-V and T-s diagrams, and animates the full cycle — piston motion for IC engine cycles and a live steam flow animation for the Rankine cycle.

---

## Files

```
main_engine.m        ← run this for command-line use
engine_gui.m         ← simple GUI with buttons for each cycle
otto_engine.m        ← Otto cycle calculations
diesel_engine.m      ← Diesel cycle calculations
dual_engine.m        ← Dual cycle calculations
rankine_cycle.m      ← Rankine cycle calculations
plot_cycle.m         ← draws the P-V diagram (IC cycles)
plot_rankine.m       ← draws the T-s and P-V diagrams (Rankine)
rankine_animation.m  ← live steam flow animation + T-s trace
pidton_animation.m   ← piston animation (5 strokes, IC cycles)
compare_cycles.m     ← bar chart comparing efficiency of all three IC cycles
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

**Piston animation only (IC cycles):**
```matlab
>> pidton_animation
```
Type `otto`, `diesel`, or `dual` when asked.

**Rankine animation only:**
```matlab
>> rankine_animation(result)
```
Pass the result struct from `rankine_cycle` directly.

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

### Rankine — `rankine_cycle(P_boiler, P_cond, T_boiler, m_dot)`
| Input | What it is |
|-------|------------|
| `P_boiler` | Boiler pressure (Pa) |
| `P_cond` | Condenser pressure (Pa) |
| `T_boiler` | Boiler (superheated steam) temperature (K) |
| `m_dot` | Mass flow rate (kg/s) |

> Note: Rankine does not use `gamma` — it uses steam enthalpy approximations instead of ideal gas equations.

---

## Output

### IC Cycles (Otto, Diesel, Dual)
All three functions return the same struct:
```matlab
result.P            % pressure at each state point (Pa)
result.T            % temperature at each state point (K)
result.V            % volume at each state point (m³)
result.Work         % net work output (J)
result.Efficiency   % thermal efficiency (0–1)
```

### Rankine Cycle
```matlab
result.T            % temperature at each state point (K)
result.P            % pressure at each state point (Pa)
result.h            % specific enthalpy at each state point (kJ/kg)
result.s            % specific entropy at each state point (kJ/kg·K)
result.x4           % dryness fraction at turbine exit
result.Wpump        % pump work (kJ/kg)
result.Wturb        % turbine work (kJ/kg)
result.Wnet         % net work output (kJ/kg)
result.Qin          % heat input at boiler (kJ/kg)
result.Qout         % heat rejected at condenser (kJ/kg)
result.eta          % thermal efficiency (0–1)
result.Power        % power output (kW)
result.T_cond       % condenser saturation temperature (K)
result.T_boil       % boiler temperature (K)
result.m_dot        % mass flow rate (kg/s)
```

---

## Quick Example

**IC cycle:**
```matlab
P1 = 101325;  T1 = 300;  V1 = 0.0005;
r = 8;  T3 = 2000;  gamma = 1.4;
result = otto_engine(P1, T1, V1, r, T3, gamma);
fprintf('Work: %.1f J,  Eta: %.1f%%\n', result.Work, result.Efficiency*100);
plot_cycle(result, 1);
```

**Rankine cycle:**
```matlab
P_boiler = 3000000;   % 30 bar
P_cond   = 10000;     % 0.1 bar
T_boiler = 823;       % 550 degrees C in Kelvin
m_dot    = 1;         % 1 kg/s
result = rankine_cycle(P_boiler, P_cond, T_boiler, m_dot);
fprintf('Eta: %.1f%%,  Power: %.1f kW\n', result.eta*100, result.Power);
plot_rankine(result);
rankine_animation(result);
```

Expected output for the above values: ~43–46% thermal efficiency, ~1500 kW power output.

---

## Rankine Cycle — Four States

| State | Location | Condition |
|-------|----------|-----------|
| 1 | Condenser exit | Saturated liquid |
| 2 | Pump exit | Compressed liquid |
| 3 | Boiler exit | Superheated steam |
| 4 | Turbine exit | Wet steam |

The cycle runs: Pump → Boiler → Turbine → Condenser → repeat.

---

## Rankine Animation

`rankine_animation.m` opens a two-panel live animation window:

**Left panel — Component flow diagram:**
- Four components displayed as boxes: Boiler, Turbine, Condenser, Pump
- Active component glows in the stage colour as steam passes through it
- A dot moves along the pipes showing the direction of steam and water flow
- State values (P, T, h) update in a live info box as each stage runs

**Right panel — T-s diagram live trace:**
- The cycle path draws itself on the T-s diagram in real time
- A moving dot follows the steam state through each stage
- Saturation dome shown as background reference

Controls:
- Speed slider — drag left for faster, right for slower
- Play button — starts the animation
- Reset button — clears the trace and resets the dot

---

## Piston Animation — 5 Strokes (IC Cycles)

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

## Comparing IC Cycles

```matlab
>> compare_cycles
```

Runs all three IC cycles with the same base conditions (r = 8, P1 = 101325 Pa, T1 = 300 K) and plots a bar chart of their thermal efficiencies side by side.

Default values used internally:
- Otto: T3 = 2000 K
- Diesel: rc = 2
- Dual: rc = 2, rp = 1.5

---

## Assumptions

**IC Cycles:**
- Ideal gas throughout
- cᵥ = 718 J/kg·K, cₚ = γ · cᵥ
- Isentropic compression and expansion
- No friction, no blow-by

**Rankine Cycle:**
- Simplified steam property approximations (not full IAPWS steam tables)
- Isentropic pump and turbine
- Saturation temperature approximated from pressure
- Superheated steam enthalpy estimated from reference values at 1 atm

---

## Requirements

MATLAB R2018b or newer. No extra toolboxes needed.
