clc
clear

disp('Select Engine Cycle:')
disp('1. Otto Cycle')
disp('2. Diesel Cycle')
disp('3. Dual Cycle')

choice = input('Enter your choice (1/2/3): ');

gamma = input('Enter gamma: ');

switch choice

    case 1
        disp('--- Otto Cycle ---')
        P1 = input('P1: ');
        T1 = input('T1: ');
        V1 = input('V1: ');
        r  = input('Compression ratio: ');
        T3 = input('Max Temp: ');
        
        result = otto_engine(P1,T1,V1,r,T3,gamma);

    case 2
        disp('--- Diesel Cycle ---')
        P1 = input('P1: ');
        T1 = input('T1: ');
        V1 = input('V1: ');
        r  = input('Compression ratio: ');
        rc = input('Cutoff ratio: ');
        
        result = diesel_engine(P1,T1,V1,r,rc,gamma);

    case 3
        disp('--- Dual Cycle ---')
        P1 = input('P1: ');
        T1 = input('T1: ');
        V1 = input('V1: ');
        r  = input('Compression ratio: ');
        rc = input('Cutoff ratio: ');
        rp = input('Pressure ratio: ');
        
        result = dual_engine(P1,T1,V1,r,rc,rp,gamma);
        
    otherwise
        disp('Invalid choice')
        return

end


disp(result)

%  AUTOMATIC P-V DIAGRAM
plot_cycle(result, choice)