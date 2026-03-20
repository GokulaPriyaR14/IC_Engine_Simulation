% =========================================================================
%  THERMODYNAMIC CYCLE ANIMATION  —  Otto / Diesel / Dual
%
%  5-stroke sequence (all cycles):
%    1. Intake      : piston TDC -> BDC, fresh charge enters (green)
%    2. Compression : piston BDC -> TDC, charge compressed  (blue->white)
%    3. Heat Add.   : combustion at TDC (cycle-dependent piston motion)
%    4. Expansion   : piston pushed to BDC, work output     (orange->red)
%    5. Exhaust     : piston BDC -> TDC, burnt gas expelled (grey)
%
%  Heat addition details:
%    Otto  : constant volume  -> piston STAYS at TDC
%    Diesel: constant pressure-> piston moves DOWN (isobaric expansion)
%    Dual  : CV first, then CP-> piston stationary then moves DOWN
% =========================================================================

clc; clear; close all;

cycle = lower(input('Enter cycle (otto / diesel / dual): ', 's'));
while ~ismember(cycle, {'otto','diesel','dual'})
    cycle = lower(input('Invalid. Enter otto / diesel / dual: ', 's'));
end

top       =  1;        % TDC position (normalised)
bottom    = -1;        % BDC position (normalised)
nFrames   =  100;      % frames per stroke  (lower = faster)
pauseTime =  0.01;     % seconds between frames
r_cutoff  =  0.30;     % fraction of stroke piston descends during CP phase

% Piston position at END of heat addition (used as start of expansion)
switch cycle
    case 'otto'
        y_ha_end = top;
    case {'diesel','dual'}
        y_ha_end = top + (bottom - top) * r_cutoff;
end

figure('Color','k','Name',['Cycle: ' upper(cycle)])

% =========================================================================
%  STROKE 1 — INTAKE   (TDC -> BDC, both valves: IN open, EX closed)
% =========================================================================
for i = 1:nFrames
    y = top + (bottom - top) * (i/nFrames);
    drawScene(y, top, bottom, [0.15 0.70 0.15], i/nFrames, ...
        'Stroke 1 : Intake', 'Fresh charge entering', cycle, 'intake');
    pause(pauseTime)
end

% =========================================================================
%  STROKE 2 — COMPRESSION   (BDC -> TDC, both valves closed)
% =========================================================================
for i = 1:nFrames
    frac = i/nFrames;
    y    = bottom + (top - bottom) * frac;
    % Colour shifts blue -> bright blue-white as gas heats under compression
    col  = min([0.10 + 0.55*frac,  0.40 + 0.30*frac,  1.0], 1.0);
    drawScene(y, top, bottom, col, frac, ...
        'Stroke 2 : Compression', 'Both valves closed', cycle, 'compress');
    pause(pauseTime)
end

% =========================================================================
%  STROKE 3 — HEAT ADDITION   (both valves closed)
%
%  OTTO   : constant volume  -> piston LOCKED at TDC
%           Glow animates white -> red (temp & pressure rise visible)
%  DIESEL : constant pressure-> piston moves DOWN by r_cutoff of stroke
%           Colour animates orange -> bright orange
%  DUAL   : first half CV (piston still, white->red)
%           second half CP (piston moves down, red->orange)
% =========================================================================
for i = 1:nFrames
    frac = i/nFrames;

    switch cycle
        case 'otto'
            y   = top;                          % piston does NOT move
            col = [1,  1-frac,  1-frac];        % white -> red
            sub = 'Constant Volume — piston fixed at TDC';

        case 'diesel'
            y   = top + (y_ha_end - top)*frac;  % piston moves DOWN
            col = [1,  0.30 + 0.40*frac,  0];  % orange brightens
            sub = 'Constant Pressure — piston moves down';

        case 'dual'
            half = nFrames/2;
            if i <= half                        % ---- CV phase ----
                cv_f = i/half;
                y    = top;                     % piston does NOT move
                col  = [1,  1-cv_f,  1-cv_f];  % white -> red
                sub  = 'Phase 1 : Constant Volume (piston fixed)';
            else                                % ---- CP phase ----
                cp_f = (i-half)/half;
                y    = top + (y_ha_end - top)*cp_f;  % piston moves DOWN
                col  = [1,  0.20 + 0.50*cp_f,  0];  % red -> orange
                sub  = 'Phase 2 : Constant Pressure (piston moves down)';
            end
    end

    drawScene(y, top, bottom, col, frac, ...
        'Stroke 3 : Heat Addition', sub, cycle, 'heat');
    pause(pauseTime)
end

% =========================================================================
%  STROKE 4 — EXPANSION / POWER   (y_ha_end -> BDC, both valves closed)
% =========================================================================
for i = 1:nFrames
    frac = i/nFrames;
    y    = y_ha_end + (bottom - y_ha_end)*frac;
    col  = max([1.0 - 0.40*frac,  0.35 - 0.25*frac,  0], 0);
    drawScene(y, top, bottom, col, frac, ...
        'Stroke 4 : Expansion (Power)', 'Both valves closed', cycle, 'expand');
    pause(pauseTime)
end

% =========================================================================
%  STROKE 5 — EXHAUST   (BDC -> TDC, EX open)
% =========================================================================
for i = 1:nFrames
    frac = i/nFrames;
    y    = bottom + (top - bottom)*frac;
    col  = [0.50 - 0.30*frac,  0.50 - 0.30*frac,  0.50 - 0.30*frac];
    drawScene(y, top, bottom, col, frac, ...
        'Stroke 5 : Exhaust', 'Burnt gas expelled', cycle, 'exhaust');
    pause(pauseTime)
end

% Cycle complete banner
drawScene(top, top, bottom, [0.20 0.90 0.30], 1.0, ...
    '*** Cycle Complete ***', '', cycle, 'done');

% =========================================================================
%  DRAWING FUNCTION
% =========================================================================
function drawScene(y, top, bottom, color, frac, phase, sub, cycle, strokeType)

    clf;  hold on
    ax = gca;
    axis(ax, [-1.70,  1.70,  bottom-0.25,  top+0.42])
    axis manual
    set(ax, 'Color','k', 'XColor','none', 'YColor','none', ...
            'LooseInset',[0 0 0 0])

    CX = -0.50;   % cylinder left x
    CW =  1.00;   % cylinder inner width
    PH =  0.07;   % piston block height

    % Clamp piston to cylinder interior
    y = min(max(y, bottom), top - PH);

    % ---------------------------------------------------------------------
    %  GAS FILL between piston face and cylinder head
    % ---------------------------------------------------------------------
    gas_bot = y + PH;
    gas_h   = top - gas_bot;          % will be ~0 at TDC (Otto heat add.)

    if gas_h > 0
        rectangle('Position',[CX, gas_bot, CW, gas_h], ...
            'FaceColor',color, 'EdgeColor','none')
    end

    % ---------------------------------------------------------------------
    %  HEAT ADDITION GLOW — drawn over full chamber height so it is
    %  clearly visible even when gas_h ≈ 0 (Otto at TDC)
    % ---------------------------------------------------------------------
    if strcmp(strokeType,'heat')

        % Full-chamber glow rectangle (fixed height = full stroke / 8)
        glow_h   = (top - bottom) / 8;
        glow_col = min(color + [0.30, 0.22, 0.22], 1);
        rectangle('Position',[CX+0.10, top-glow_h, CW-0.20, glow_h], ...
            'FaceColor', glow_col, 'EdgeColor','none', 'Curvature',[0.5,0.5])

        % Spark dot at cylinder head for CV combustion (Otto / Dual-CV)
        is_cv = strcmp(cycle,'otto') || ...
                (strcmp(cycle,'dual') && frac <= 0.52);
        if is_cv
            % Outer halo
            scatter(0, top-0.07, 160, [1.0 0.9 0.3], 'filled', ...
                'MarkerFaceAlpha', min(frac*1.6, 0.85))
            % Bright core
            scatter(0, top-0.07,  50, [1.0 1.0 1.0], 'filled', ...
                'MarkerFaceAlpha', min(frac*2.5, 1.00))
        end
    end

    % ---------------------------------------------------------------------
    %  CYLINDER WALLS  (drawn after gas fill so walls sit on top)
    % ---------------------------------------------------------------------
    rectangle('Position',[CX, bottom, CW, top-bottom], ...
        'EdgeColor',[0.82 0.82 0.82], 'LineWidth',2.0, 'FaceColor','none')

    % Cylinder head (thick top cap)
    line([CX, CX+CW], [top, top], 'Color',[0.85 0.85 0.85], 'LineWidth',4)

    % ---------------------------------------------------------------------
    %  VALVE INDICATORS   Left = IN (intake),  Right = EX (exhaust)
    % ---------------------------------------------------------------------
    iv_open = strcmp(strokeType,'intake');
    ev_open = strcmp(strokeType,'exhaust');

    IN_col  = [0.10, 0.88, 0.10];   % bright green  = intake
    EX_col  = [0.92, 0.38, 0.08];   % orange-red    = exhaust
    DIM     = [0.32, 0.32, 0.32];   % dim grey      = closed

    % Stems
    line([-0.22,-0.22],[top, top+0.11], ...
        'Color', pick(iv_open,IN_col,DIM), 'LineWidth',3.5)
    line([ 0.22, 0.22],[top, top+0.11], ...
        'Color', pick(ev_open,EX_col,DIM), 'LineWidth',3.5)

    % Labels
    text(-0.22, top+0.17, 'IN', ...
        'Color', pick(iv_open,IN_col,DIM), ...
        'FontSize',8, 'HorizontalAlignment','center', 'FontWeight','bold')
    text( 0.22, top+0.17, 'EX', ...
        'Color', pick(ev_open,EX_col,DIM), ...
        'FontSize',8, 'HorizontalAlignment','center', 'FontWeight','bold')

    % ---------------------------------------------------------------------
    %  PISTON BLOCK
    % ---------------------------------------------------------------------
    rectangle('Position',[CX, y, CW, PH], ...
        'FaceColor',[0.76 0.76 0.76], 'EdgeColor',[0.45 0.45 0.45], 'LineWidth',1)

    % Piston pin (centre dot)
    plot(0, y + PH/2, 'o', 'MarkerSize',5, ...
        'MarkerFaceColor',[0.50 0.50 0.50], 'MarkerEdgeColor','none')

    % ---------------------------------------------------------------------
    %  CONNECTING ROD + CRANKSHAFT
    % ---------------------------------------------------------------------
    rod_cy = bottom - 0.14;   % crank centre y
    r_cr   = 0.09;            % crank throw radius

    % Crank circle
    th = linspace(0,2*pi,60);
    plot(r_cr*cos(th), rod_cy + r_cr*sin(th), ...
        'Color',[0.52 0.52 0.52], 'LineWidth',1)

    % Crank pin (follows piston via slider-crank geometry, simplified)
    sn = (y - bottom)/(top - bottom);          % 0 at BDC, 1 at TDC
    ca = acos(max(min(2*sn - 1, 1), -1));       % crank angle [0, pi]
    pin_x =  r_cr * sin(ca);
    pin_y  = rod_cy - r_cr * cos(ca);

    % Connecting rod line
    line([0, pin_x], [y, pin_y], 'Color',[0.58 0.58 0.58], 'LineWidth',1.8)

    % Pin dot
    plot(pin_x, pin_y, 'o', 'MarkerSize',6, ...
        'MarkerFaceColor',[0.78 0.78 0.78], 'MarkerEdgeColor',[0.42 0.42 0.42])

    % Piston rod (wrist-pin to crank-pin already drawn; add vertical stem)
    line([0, 0], [y, rod_cy], 'Color',[0.60 0.60 0.60], 'LineWidth',2.5)

    % ---------------------------------------------------------------------
    %  TDC / BDC REFERENCE MARKS
    % ---------------------------------------------------------------------
    xr = CX + CW;
    line([xr, xr+0.07],[top,    top],    'Color',[0.40 0.40 0.40],'LineWidth',0.8)
    line([xr, xr+0.07],[bottom, bottom], 'Color',[0.40 0.40 0.40],'LineWidth',0.8)
    text(xr+0.09, top,    'TDC','Color',[0.48 0.48 0.48], ...
        'FontSize',7,'VerticalAlignment','middle')
    text(xr+0.09, bottom, 'BDC','Color',[0.48 0.48 0.48], ...
        'FontSize',7,'VerticalAlignment','middle')

    % ---------------------------------------------------------------------
    %  TEXT LABELS  (left margin)
    % ---------------------------------------------------------------------
    text(-1.65, top+0.35, ['Cycle : ' upper(cycle)], ...
        'Color','w', 'FontSize',12, 'FontWeight','bold')
    text(-1.65, top+0.23, phase, ...
        'Color',[1.0 0.85 0.20], 'FontSize',10)
    if ~isempty(sub)
        text(-1.65, top+0.12, sub, ...
            'Color',[0.55 0.88 1.00], 'FontSize',8)
    end

    drawnow limitrate
end

% =========================================================================
%  HELPER — inline if/else for colour selection
% =========================================================================
function c = pick(cond, a, b)
    if cond;  c = a;  else;  c = b;  end
end