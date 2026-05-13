function result = rankine_cycle(P_boiler, P_cond, T_boiler, m_dot)

% ── Constants ─────────────────────────────────────────────────
% Simplified steam approximations
% Using Antoine-style saturation approximations
% All enthalpies in kJ/kg, entropy in kJ/kg.K

% ── State 1: Condenser exit (saturated liquid) ────────────────
% Saturation temperature from pressure (approximate)
T_cond = 373 * (P_cond / 101325)^0.25;   % K, approximate
if T_cond < 273; T_cond = 273; end

h1 = 4.18 * (T_cond - 273);              % hf at condenser (kJ/kg)
s1 = 4.18 * log(T_cond / 273);           % sf at condenser (kJ/kg.K)
v1 = 0.001;                               % specific volume liquid (m3/kg)

% ── State 2: Pump exit (compressed liquid) ────────────────────
% Pump work = v1 * (P_boiler - P_cond)
W_pump = v1 * (P_boiler - P_cond) / 1000; % kJ/kg
h2 = h1 + W_pump;
s2 = s1;                                   % isentropic pump
T2 = T_cond;                               % approx same temperature

% ── State 3: Boiler exit (superheated steam) ──────────────────
T3 = T_boiler;                             % K
% Approximate superheated enthalpy
h_fg_ref = 2257;                           % kJ/kg at 100C
h_g_ref  = 2676;                           % kJ/kg at 100C, 1atm
% Correction for pressure and temperature
h3 = h_g_ref + 1.87*(T3 - 373) - 0.5*log(P_boiler/101325)*50;
h3 = max(h3, h_g_ref);                    % floor at saturation

s_g_ref  = 7.355;                          % kJ/kg.K at 1atm
s3 = s_g_ref + 1.87*log(T3/373) - 0.287*log(P_boiler/101325);
P3 = P_boiler;

% ── State 4: Turbine exit (wet steam) ────────────────────────
% Isentropic expansion
s4 = s3;
% Saturation properties at condenser
h_f4  = h1;
s_f4  = s1;
h_fg4 = 2257 * (T_cond/373)^0.5;
s_fg4 = h_fg4 / T_cond;
s_g4  = s_f4 + s_fg4;

% Dryness fraction
if s4 >= s_g4
    x4 = 1.0;
else
    x4 = (s4 - s_f4) / s_fg4;
    x4 = max(0, min(1, x4));
end

h4   = h_f4 + x4 * h_fg4;
T4   = T_cond;
P4   = P_cond;
s4_actual = s_f4 + x4*s_fg4;

% ── Energy calculations ───────────────────────────────────────
Q_boiler    = h3 - h2;                    % Heat input (kJ/kg)
Q_condenser = h4 - h1;                    % Heat rejected (kJ/kg)
W_turbine   = h3 - h4;                    % Turbine work (kJ/kg)
W_net       = W_turbine - W_pump;         % Net work (kJ/kg)
eta         = W_net / Q_boiler;           % Thermal efficiency
W_power     = W_net * m_dot;              % Power output (kW)
COP_boiler  = Q_boiler * m_dot;          % Heat input rate (kW)

% ── Store results ─────────────────────────────────────────────
result.T      = [T_cond, T2, T3, T4];
result.P      = [P_cond, P_boiler, P_boiler, P_cond];
result.h      = [h1, h2, h3, h4];
result.s      = [s1, s2, s3, s4_actual];
result.x4     = x4;
result.Wpump  = W_pump;
result.Wturb  = W_turbine;
result.Wnet   = W_net;
result.Qin    = Q_boiler;
result.Qout   = Q_condenser;
result.eta    = eta;
result.Power  = W_power;
result.m_dot  = m_dot;
result.T_cond = T_cond;
result.T_boil = T_boiler;

end