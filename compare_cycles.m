function compare_cycles()

gamma = 1.4;
r = 8;

% Dummy inputs
P1 = 101325; T1 = 300; V1 = 0.0005;

otto = otto_engine(P1,T1,V1,r,2000,gamma);
diesel = diesel_engine(P1,T1,V1,r,2,gamma);
dual = dual_engine(P1,T1,V1,r,2,1.5,gamma);

eff = [otto.Efficiency diesel.Efficiency dual.Efficiency];

figure
bar(eff)

set(gca,'XTickLabel',{'Otto','Diesel','Dual'})
ylabel('Efficiency')
title('Cycle Efficiency Comparison')

end