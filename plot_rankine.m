function plot_rankine(result)

% ── Colors ────────────────────────────────────────────────────
BG   = [0.08 0.08 0.10];
GRID = [0.22 0.22 0.25];
CYAN = [0.00 0.74 0.84];
ORG  = [1.00 0.60 0.15];
GRN  = [0.20 0.85 0.40];
WHT  = [1.00 1.00 1.00];
DIM  = [0.70 0.70 0.75];
RED  = [0.90 0.30 0.20];

fig = figure('Name','Rankine Cycle Analysis', ...
    'Position',[80 50 1280 740], ...
    'Color',BG,'NumberTitle','off', ...
    'MenuBar','none','ToolBar','none');

% ── Title using uicontrol (no overlap) ───────────────────────
uicontrol(fig,'Style','text', ...
    'String','RANKINE CYCLE ANALYSIS', ...
    'Units','pixels','Position',[0 705 1280 30], ...
    'FontSize',16,'FontWeight','bold', ...
    'ForegroundColor',CYAN,'BackgroundColor',BG, ...
    'HorizontalAlignment','center');

% ── Results strip using uicontrol (no overlap) ───────────────
results_str = sprintf(['Turbine Work: %.2f kJ/kg   |   ' ...
    'Pump Work: %.2f kJ/kg   |   ' ...
    'Net Work: %.2f kJ/kg   |   ' ...
    'Heat Input: %.2f kJ/kg   |   ' ...
    'Efficiency: %.1f %%   |   ' ...
    'Power: %.2f kW   |   ' ...
    'Dryness x4: %.3f   |   ' ...
    'T_cond: %.1f K   |   ' ...
    'T_boil: %.1f K'], ...
    result.Wturb, result.Wpump, result.Wnet, ...
    result.Qin, result.eta*100, result.Power, ...
    result.x4, result.T_cond, result.T_boil);

uicontrol(fig,'Style','text', ...
    'String',results_str, ...
    'Units','pixels','Position',[0 0 1280 40], ...
    'FontSize',9,'FontWeight','bold', ...
    'ForegroundColor',GRN,'BackgroundColor',[0.10 0.10 0.13], ...
    'HorizontalAlignment','center');

% ── T-s Diagram ──────────────────────────────────────────────
ax1 = axes(fig,'Units','pixels','Position',[60 65 530 610]);
ax1.Color     = [0.10 0.10 0.13];
ax1.XColor    = DIM;
ax1.YColor    = DIM;
ax1.GridColor = GRID;
ax1.XGrid     = 'on';
ax1.YGrid     = 'on';
ax1.Box       = 'off';
ax1.FontSize  = 10;
uistack(ax1,'top');
hold(ax1,'on');

s = result.s;
T = result.T;

% Saturation dome
T_sat = linspace(273, result.T_boil*0.95, 100);
s_f   = 4.18 * log(T_sat/273);
s_fg  = 2257 * (T_sat/373).^0.5 ./ T_sat;
s_g   = s_f + s_fg;
fill(ax1,[s_f, fliplr(s_g)],[T_sat, fliplr(T_sat)], ...
    [0.15 0.15 0.20],'EdgeColor',[0.35 0.35 0.40], ...
    'FaceAlpha',0.6,'LineWidth',1);

% 1→2 Pump
plot(ax1,[s(1) s(2)],[T(1) T(2)],'Color',ORG,'LineWidth',2.5);
% 2→3 Boiler
plot(ax1,linspace(s(2),s(3),50),linspace(T(2),T(3),50), ...
    'Color',GRN,'LineWidth',2.5);
% 3→4 Turbine
plot(ax1,[s(3) s(4)],[T(3) T(4)],'Color',CYAN,'LineWidth',2.5);
% 4→1 Condenser
plot(ax1,linspace(s(4),s(1),50),ones(1,50)*T(1), ...
    'Color',RED,'LineWidth',2.5);

% State points
scatter(ax1,s,T,90,WHT,'filled');
lbls   = {'1 (Cond.Exit)','2 (Pump Exit)','3 (Boiler Exit)','4 (Turb.Exit)'};
xoff   = [-0.3 -0.3 0.1 0.1];
yoff   = [15 -25 15 -25];
for i = 1:4
    text(ax1,s(i)+xoff(i),T(i)+yoff(i),lbls{i}, ...
        'Color',WHT,'FontSize',9,'FontWeight','bold');
end

ax1.Title.String   = 'T-s Diagram';
ax1.Title.Color    = WHT;
ax1.Title.FontSize = 13;
ax1.XLabel.String  = 'Entropy  s  (kJ/kg·K)';
ax1.XLabel.Color   = DIM;
ax1.YLabel.String  = 'Temperature  T  (K)';
ax1.YLabel.Color   = DIM;
legend(ax1,{'Saturation Dome','1→2 Pump','2→3 Boiler', ...
    '3→4 Turbine','4→1 Condenser'}, ...
    'Location','northwest','TextColor',WHT, ...
    'Color',[0.12 0.12 0.15],'EdgeColor',GRID,'FontSize',8);
hold(ax1,'off');

% ── P-V Diagram ──────────────────────────────────────────────
ax2 = axes(fig,'Units','pixels','Position',[670 65 560 610]);
ax2.Color     = [0.10 0.10 0.13];
ax2.XColor    = DIM;
ax2.YColor    = DIM;
ax2.GridColor = GRID;
ax2.XGrid     = 'on';
ax2.YGrid     = 'on';
ax2.Box       = 'off';
ax2.FontSize  = 10;
uistack(ax2,'top');
hold(ax2,'on');

P  = result.P/1000;
v1 = 0.001;
v2 = 0.001;
R_steam = 0.4615;
v3 = R_steam * result.T(3) / (result.P(3)/1000);
v4 = v1 + result.x4 * (R_steam*result.T(4)/(result.P(4)/1000) - v1);
V  = [v1 v2 v3 v4];

% 1→2 Pump
plot(ax2,[V(1) V(2)],[P(1) P(2)],'Color',ORG,'LineWidth',2.5);
% 2→3 Boiler
plot(ax2,linspace(V(2),V(3),50),ones(1,50)*P(3), ...
    'Color',GRN,'LineWidth',2.5);
% 3→4 Turbine
v_t = linspace(V(3),V(4),50);
plot(ax2,v_t,P(3)*(V(3)./v_t).^1.3,'Color',CYAN,'LineWidth',2.5);
% 4→1 Condenser
plot(ax2,linspace(V(4),V(1),50),ones(1,50)*P(4), ...
    'Color',RED,'LineWidth',2.5);

% State points
scatter(ax2,V,P,90,WHT,'filled');
xoff2 = [0.01 0.01 0.05 0.05];
yoff2 = [30 -50 30 -50];
for i = 1:4
    text(ax2,V(i)+xoff2(i),P(i)+yoff2(i),lbls{i}, ...
        'Color',WHT,'FontSize',9,'FontWeight','bold');
end

ax2.Title.String   = 'P-V Diagram';
ax2.Title.Color    = WHT;
ax2.Title.FontSize = 13;
ax2.XLabel.String  = 'Specific Volume  v  (m³/kg)';
ax2.XLabel.Color   = DIM;
ax2.YLabel.String  = 'Pressure  P  (kPa)';
ax2.YLabel.Color   = DIM;
legend(ax2,{'1→2 Pump','2→3 Boiler','3→4 Turbine','4→1 Condenser'}, ...
    'Location','northeast','TextColor',WHT, ...
    'Color',[0.12 0.12 0.15],'EdgeColor',GRID,'FontSize',8);
hold(ax2,'off');

drawnow;
end