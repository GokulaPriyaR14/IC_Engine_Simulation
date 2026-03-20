function engine_gui()

f = figure('Position',[500 300 300 250],'Name','Engine Simulator');

uicontrol(f,'Style','pushbutton','String','Otto Cycle',...
    'Position',[50 150 200 40],...
    'Callback',@(src,event) run_cycle(1));

uicontrol(f,'Style','pushbutton','String','Diesel Cycle',...
    'Position',[50 100 200 40],...
    'Callback',@(src,event) run_cycle(2));

uicontrol(f,'Style','pushbutton','String','Dual Cycle',...
    'Position',[50 50 200 40],...
    'Callback',@(src,event) run_cycle(3));

end

function run_cycle(choice)

P1=101325; T1=300; V1=0.0005; gamma=1.4;

if choice==1
    result = otto_engine(P1,T1,V1,8,2000,gamma);
elseif choice==2
    result = diesel_engine(P1,T1,V1,8,2,gamma);
else
    result = dual_engine(P1,T1,V1,8,2,1.5,gamma);
end

plot_cycle(result,choice)

end