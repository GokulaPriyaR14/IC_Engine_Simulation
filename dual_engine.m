function result = dual_engine(P1,T1,V1,r,rc,rp,gamma)

cv = 718;

V2 = V1/r;
T2 = T1 * r^(gamma-1);
P2 = P1 * r^gamma;

% Constant volume heat addition
P3 = rp * P2;
T3 = T2 * rp;
V3 = V2;

% Constant pressure heat addition
V4 = rc * V3;
T4 = T3 * rc;
P4 = P3;

% Expansion
V5 = V1;
T5 = T4 * (1/r)^(gamma-1);
P5 = P4 * (1/r)^gamma;

cp = gamma * cv;

Qin = cv*(T3-T2) + cp*(T4-T3);
Qout = cv*(T5-T1);

W = Qin - Qout;
eta = W/Qin;

result.P = [P1 P2 P3 P4 P5];
result.T = [T1 T2 T3 T4 T5];
result.V = [V1 V2 V3 V4 V5];
result.Work = W;
result.Efficiency = eta;

end