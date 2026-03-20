function plot_cycle(result, choice)

P = result.P;
V = result.V;

figure
hold on
grid on

if choice == 1 || choice == 2
    % 4-point cycles
    plot([V(1) V(2)], [P(1) P(2)], 'r','LineWidth',2)
    plot([V(2) V(3)], [P(2) P(3)], 'g','LineWidth',2)
    plot([V(3) V(4)], [P(3) P(4)], 'b','LineWidth',2)
    plot([V(4) V(1)], [P(4) P(1)], 'k','LineWidth',2)
     legend('Isentropic Compression', ...
           'Constant Volume/pressure Heat Addition', ...
           'Isentropic Expansion', ...
           'Constant Volume Heat Rejection')

else
    % Dual cycle (5 points)
    plot([V(1) V(2)], [P(1) P(2)], 'r','LineWidth',2)
    plot([V(2) V(3)], [P(2) P(3)], 'g','LineWidth',2)
    plot([V(3) V(4)], [P(3) P(4)], 'b','LineWidth',2)
    plot([V(4) V(5)], [P(4) P(5)], 'm','LineWidth',2)
    plot([V(5) V(1)], [P(5) P(1)], 'k','LineWidth',2)
     legend('Isentropic Compression', ...
           'Constant Volume Heat Addition', ...
           'Constant Pressure Heat Addition', ...
           'Isentropic Expansion', ...
           'Constant Volume Heat Rejection')
end

xlabel('Volume')
ylabel('Pressure')
title('P-V Diagram')

end