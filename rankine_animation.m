function rankine_animation(result)

BG   = [0.08 0.08 0.10];
GRID = [0.22 0.22 0.25];
CYAN = [0.00 0.74 0.84];
ORG  = [1.00 0.60 0.15];
GRN  = [0.20 0.85 0.40];
WHT  = [1.00 1.00 1.00];
DIM  = [0.70 0.70 0.75];
DARK = [0.10 0.10 0.13];

% ── Figure ───────────────────────────────────────────────────
fig = figure('Name','Rankine Cycle Animation', ...
    'Position',[60 40 1300 740], ...
    'Color',BG,'NumberTitle','off', ...
    'MenuBar','none','ToolBar','none');

% ── Title ────────────────────────────────────────────────────
uicontrol(fig,'Style','text', ...
    'String','RANKINE CYCLE — LIVE ANIMATION', ...
    'Units','pixels','Position',[0 705 1300 30], ...
    'FontSize',15,'FontWeight','bold', ...
    'ForegroundColor',CYAN,'BackgroundColor',BG, ...
    'HorizontalAlignment','center');

% ══════════════════════════════════════════════════════════════
%  LEFT — COMPONENT FLOW DIAGRAM
% ══════════════════════════════════════════════════════════════
ax1 = axes(fig,'Units','pixels','Position',[30 60 580 620]);
ax1.Color = DARK; ax1.XColor = DARK; ax1.YColor = DARK;
ax1.XTick = []; ax1.YTick = [];
ax1.Box = 'off';
ax1.XLim = [0 10]; ax1.YLim = [0 10];
uistack(ax1,'top');
hold(ax1,'on');

% ── Component boxes ──────────────────────────────────────────
boiler_patch    = patch(ax1,[1 4 4 1],[6.5 6.5 8.5 8.5], ...
    DARK,'EdgeColor',DIM,'LineWidth',2);
turbine_patch   = patch(ax1,[6 9 9 6],[6.5 6.5 8.5 8.5], ...
    DARK,'EdgeColor',DIM,'LineWidth',2);
condenser_patch = patch(ax1,[6 9 9 6],[1.5 1.5 3.5 3.5], ...
    DARK,'EdgeColor',DIM,'LineWidth',2);
pump_patch      = patch(ax1,[1 4 4 1],[1.5 1.5 3.5 3.5], ...
    DARK,'EdgeColor',DIM,'LineWidth',2);

% Component labels
text(ax1,2.5,8.8,'BOILER','Color',WHT,'FontSize',11, ...
    'FontWeight','bold','HorizontalAlignment','center');
text(ax1,7.5,8.8,'TURBINE','Color',WHT,'FontSize',11, ...
    'FontWeight','bold','HorizontalAlignment','center');
text(ax1,7.5,3.8,'CONDENSER','Color',WHT,'FontSize',11, ...
    'FontWeight','bold','HorizontalAlignment','center');
text(ax1,2.5,3.8,'PUMP','Color',WHT,'FontSize',11, ...
    'FontWeight','bold','HorizontalAlignment','center');

% Sub labels
text(ax1,2.5,7.5,'Heat Addition','Color',DIM,'FontSize',8, ...
    'HorizontalAlignment','center');
text(ax1,7.5,7.5,'Work Output','Color',DIM,'FontSize',8, ...
    'HorizontalAlignment','center');
text(ax1,7.5,2.5,'Heat Rejection','Color',DIM,'FontSize',8, ...
    'HorizontalAlignment','center');
text(ax1,2.5,2.5,'Pressurize','Color',DIM,'FontSize',8, ...
    'HorizontalAlignment','center');

% Pipes
plot(ax1,[4 6],[7.5 7.5],'Color',DIM,'LineWidth',2);
plot(ax1,[7.5 7.5],[6.5 3.5],'Color',DIM,'LineWidth',2);
plot(ax1,[4 6],[2.5 2.5],'Color',DIM,'LineWidth',2);
plot(ax1,[2.5 2.5],[6.5 3.5],'Color',DIM,'LineWidth',2);

% Pipe labels
text(ax1,5,8.0,'Superheated Steam','Color',DIM,'FontSize',7, ...
    'HorizontalAlignment','center');
text(ax1,5,2.0,'Liquid Water','Color',DIM,'FontSize',7, ...
    'HorizontalAlignment','center');
text(ax1,8.3,5.0,'Wet Steam','Color',DIM,'FontSize',7, ...
    'HorizontalAlignment','center','Rotation',90);
text(ax1,1.7,5.0,'Compressed Liquid','Color',DIM,'FontSize',7, ...
    'HorizontalAlignment','center','Rotation',90);

% State point labels
text(ax1,1.0,6.3,'State 2','Color',DIM,'FontSize',8);
text(ax1,9.2,6.3,'State 3','Color',DIM,'FontSize',8);
text(ax1,9.2,3.7,'State 4','Color',DIM,'FontSize',8);
text(ax1,1.0,3.7,'State 1','Color',DIM,'FontSize',8);

% ── Animated elements ────────────────────────────────────────
flow_dot = plot(ax1,4,7.5,'o', ...
    'MarkerSize',14,'MarkerFaceColor',CYAN, ...
    'MarkerEdgeColor',WHT,'LineWidth',1.5);

% State info box — positioned in center gap between components
state_box = text(ax1,5,5.5,'', ...
    'Color',WHT,'FontSize',9,'FontWeight','bold', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'BackgroundColor',[0.13 0.13 0.16], ...
    'EdgeColor',CYAN,'Margin',5);

% Stage label — positioned at very bottom of axes
stage_label = text(ax1,5,0.4,'', ...
    'Color',CYAN,'FontSize',8,'FontWeight','bold', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','bottom');

hold(ax1,'off');

% ══════════════════════════════════════════════════════════════
%  RIGHT — ANIMATED T-s DIAGRAM
% ══════════════════════════════════════════════════════════════
ax2 = axes(fig,'Units','pixels','Position',[660 60 600 580]);
ax2.Color     = DARK;
ax2.XColor    = DIM; ax2.YColor = DIM;
ax2.GridColor = GRID;
ax2.XGrid = 'on'; ax2.YGrid = 'on';
ax2.Box = 'off';
uistack(ax2,'top');
hold(ax2,'on');

s = result.s;
T = result.T;

% Saturation dome
T_sat = linspace(273, result.T_boil*0.95, 100);
s_f   = 4.18*log(T_sat/273);
s_fg  = 2257*(T_sat/373).^0.5./T_sat;
s_g   = s_f + s_fg;
fill(ax2,[s_f fliplr(s_g)],[T_sat fliplr(T_sat)], ...
    [0.15 0.15 0.20],'EdgeColor',[0.35 0.35 0.40], ...
    'FaceAlpha',0.5,'LineWidth',1);

% Faint background path
s_all = [s(1) s(2) linspace(s(2),s(3),20) s(3) s(4) ...
         linspace(s(4),s(1),20) s(1)];
T_all = [T(1) T(2) linspace(T(2),T(3),20) T(3) T(4) ...
         ones(1,20)*T(1) T(1)];
plot(ax2,s_all,T_all,'Color',[0.3 0.3 0.35], ...
    'LineWidth',1,'LineStyle','--');

% State points
scatter(ax2,s,T,80,WHT,'filled');
stLbls = {'1 (Cond.Exit)','2 (Pump Exit)', ...
          '3 (Boiler Exit)','4 (Turb.Exit)'};
dT = (max(T)-min(T))*0.04;
for i = 1:4
    text(ax2,s(i),T(i)+dT,stLbls{i}, ...
        'Color',WHT,'FontSize',8,'FontWeight','bold', ...
        'HorizontalAlignment','center');
end

% Animated trace
trace_line = plot(ax2,NaN,NaN,'-','Color',CYAN,'LineWidth',3);
ts_dot     = plot(ax2,s(1),T(1),'o','MarkerSize',12, ...
    'MarkerFaceColor',ORG,'MarkerEdgeColor',WHT,'LineWidth',1.5);

ax2.Title.String  = 'T-s Diagram — Live Trace';
ax2.Title.Color   = WHT; ax2.Title.FontSize = 11;
ax2.XLabel.String = 'Entropy s (kJ/kg·K)';
ax2.XLabel.Color  = DIM;
ax2.YLabel.String = 'Temperature T (K)';
ax2.YLabel.Color  = DIM;

hold(ax2,'off');

% ── Speed control ────────────────────────────────────────────
uicontrol(fig,'Style','text','String','Animation Speed:', ...
    'Units','pixels','Position',[660 18 160 22], ...
    'FontSize',9,'ForegroundColor',DIM,'BackgroundColor',BG, ...
    'HorizontalAlignment','left');
speed_slider = uicontrol(fig,'Style','slider', ...
    'Units','pixels','Position',[820 20 200 20], ...
    'Min',0.01,'Max',0.1,'Value',0.04);
uicontrol(fig,'Style','text','String','Fast ◄─► Slow', ...
    'Units','pixels','Position',[1025 18 140 22], ...
    'FontSize',8,'ForegroundColor',DIM,'BackgroundColor',BG);

% ── Buttons ──────────────────────────────────────────────────
uicontrol(fig,'Style','pushbutton','String','▶  PLAY ANIMATION', ...
    'Units','pixels','Position',[660 10 290 42], ...
    'FontSize',12,'FontWeight','bold', ...
    'ForegroundColor',WHT,'BackgroundColor',[0.10 0.65 0.25], ...
    'Callback',@(~,~) playAnimation());
uicontrol(fig,'Style','pushbutton','String','↺  RESET', ...
    'Units','pixels','Position',[960 10 290 42], ...
    'FontSize',12,'FontWeight','bold', ...
    'ForegroundColor',WHT,'BackgroundColor',[0.55 0.25 0.75], ...
    'Callback',@(~,~) resetAnimation());

% ══════════════════════════════════════════════════════════════
%  ANIMATION
% ══════════════════════════════════════════════════════════════
    function playAnimation()
        dt = get(speed_slider,'Value');

        segments = {
            '1→2  PUMP', ...
            [0.15 0.40 0.75], ...
            [2.5], [3.5 6.5], ...
            linspace(s(1),s(2),30), linspace(T(1),T(2),30), ...
            sprintf('State 1→2  |  PUMP\nP: %.0f → %.0f kPa\nT: %.1f → %.1f K\nh: %.1f → %.1f kJ/kg', ...
                result.P(1)/1000,result.P(2)/1000, ...
                result.T(1),result.T(2), ...
                result.h(1),result.h(2));

            '2→3  BOILER', ...
            [0.20 0.85 0.40], ...
            [1 4 5 6],[7.5 7.5 7.5 7.5], ...
            linspace(s(2),s(3),30), linspace(T(2),T(3),30), ...
            sprintf('State 2→3  |  BOILER\nP: %.0f kPa (const)\nT: %.1f → %.1f K\nh: %.1f → %.1f kJ/kg\nQin: %.1f kJ/kg', ...
                result.P(3)/1000, ...
                result.T(2),result.T(3), ...
                result.h(2),result.h(3),result.Qin);

            '3→4  TURBINE', ...
            [0.00 0.74 0.84], ...
            [7.5 7.5],[6.5 3.5], ...
            linspace(s(3),s(4),30), linspace(T(3),T(4),30), ...
            sprintf('State 3→4  |  TURBINE\nP: %.0f → %.0f kPa\nT: %.1f → %.1f K\nh: %.1f → %.1f kJ/kg\nWturb: %.1f kJ/kg', ...
                result.P(3)/1000,result.P(4)/1000, ...
                result.T(3),result.T(4), ...
                result.h(3),result.h(4),result.Wturb);

            '4→1  CONDENSER', ...
            [0.90 0.25 0.20], ...
            [6 5 4],[2.5 2.5 2.5], ...
            linspace(s(4),s(1),30), ones(1,30)*T(1), ...
            sprintf('State 4→1  |  CONDENSER\nP: %.0f kPa (const)\nT: %.1f K (const)\nh: %.1f → %.1f kJ/kg\nQout: %.1f kJ/kg', ...
                result.P(4)/1000, ...
                result.T(4), ...
                result.h(4),result.h(1),result.Qout);
        };

        trace_s = s(1);
        trace_T = T(1);

        for seg = 1:4
            stage_name = segments{seg,1};
            comp_col   = segments{seg,2};
            path_x     = segments{seg,3};
            path_y     = segments{seg,4};
            ts_s       = segments{seg,5};
            ts_T       = segments{seg,6};
            state_txt  = segments{seg,7};

            resetComponentColors();
            highlightComponent(seg, comp_col);
            set(stage_label,'String',stage_name,'Color',comp_col);
            set(state_box,'String',state_txt,'EdgeColor',comp_col);

            % Flow dot animation
            n_path = length(path_x);
            if n_path > 1
                for k = 1:n_path-1
                    x_move = linspace(path_x(k),path_x(k+1),20);
                    y_move = linspace(path_y(k),path_y(k+1),20);
                    for m = 1:length(x_move)
                        if ~ishandle(fig); return; end
                        set(flow_dot,'XData',x_move(m),'YData',y_move(m), ...
                            'MarkerFaceColor',comp_col);
                        drawnow; pause(dt);
                    end
                end
            else
                y_move = linspace(path_y(1),path_y(2),30);
                for m = 1:length(y_move)
                    if ~ishandle(fig); return; end
                    set(flow_dot,'XData',path_x(1),'YData',y_move(m), ...
                        'MarkerFaceColor',comp_col);
                    drawnow; pause(dt);
                end
            end

            % T-s trace animation
            for k = 1:length(ts_s)
                if ~ishandle(fig); return; end
                trace_s(end+1) = ts_s(k); %#ok
                trace_T(end+1) = ts_T(k); %#ok
                set(trace_line,'XData',trace_s,'YData',trace_T);
                set(ts_dot,'XData',ts_s(k),'YData',ts_T(k), ...
                    'MarkerFaceColor',comp_col);
                drawnow; pause(dt*0.5);
            end
            pause(0.4);
        end

        % Final — clear state box, show summary in stage label only
        set(state_box,'String','');
        set(stage_label,'String', ...
            sprintf('Cycle Complete!   eta=%.1f%%   Wnet=%.1f kJ/kg   Power=%.1f kW', ...
            result.eta*100, result.Wnet, result.Power), ...
            'Color',GRN,'FontSize',8);
        resetComponentColors();
    end

% ══════════════════════════════════════════════════════════════
%  HELPERS
% ══════════════════════════════════════════════════════════════
    function highlightComponent(seg, col)
        patches = {boiler_patch,turbine_patch, ...
                   condenser_patch,pump_patch};
        order   = [4, 2, 3, 1];
        idx = order(seg);
        set(patches{idx},'FaceColor',col*0.3, ...
            'EdgeColor',col,'LineWidth',3);
    end

    function resetComponentColors()
        set(boiler_patch,   'FaceColor',DARK,'EdgeColor',DIM,'LineWidth',2);
        set(turbine_patch,  'FaceColor',DARK,'EdgeColor',DIM,'LineWidth',2);
        set(condenser_patch,'FaceColor',DARK,'EdgeColor',DIM,'LineWidth',2);
        set(pump_patch,     'FaceColor',DARK,'EdgeColor',DIM,'LineWidth',2);
    end

    function resetAnimation()
        set(trace_line,'XData',NaN,'YData',NaN);
        set(ts_dot,'XData',s(1),'YData',T(1));
        set(flow_dot,'XData',4,'YData',7.5,'MarkerFaceColor',CYAN);
        set(stage_label,'String','');
        set(state_box,'String','');
        resetComponentColors();
        drawnow;
    end

end