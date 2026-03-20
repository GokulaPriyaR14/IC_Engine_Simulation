function results = otto_engine(P1,T1,V1,r,T3,gamma)

cv = 718;

V2 = V1/r;

T2 = T1 * r^(gamma-1);
P2 = P1 * r^gamma;

P3 = P2 * (T3/T2);
V3 = V2;

T4 = T3 / r^(gamma-1);
P4 = P3 / r^gamma;
V4 = V1;

Qin = cv*(T3-T2);
Qout = cv*(T4-T1);

Wnet = Qin - Qout;

eta = Wnet / Qin;

results.P = [P1 P2 P3 P4];
results.T = [T1 T2 T3 T4];
results.V = [V1 V2 V3 V4];
results.Qin = Qin;
results.Qout = Qout;
results.Work = Wnet;
results.Efficiency = eta;

end