function result = diesel_engine(P1,T1,V1,r,rc,gamma)

cv = 718;

V2 = V1/r;
T2 = T1 * r^(gamma-1);
P2 = P1 * r^gamma;

% Heat addition at constant pressure
V3 = rc * V2;
T3 = T2 * rc;
P3 = P2;

% Expansion
V4 = V1;
T4 = T3 * (1/r)^(gamma-1);
P4 = P3 * (1/r)^gamma;

cp = gamma * cv;
Qin = cp*(T3-T2);
Qout = cv*(T4-T1);

W = Qin - Qout;
eta = W/Qin;

result.P = [P1 P2 P3 P4];
result.T = [T1 T2 T3 T4];
result.V = [V1 V2 V3 V4];
result.Work = W;
result.Efficiency = eta;

end