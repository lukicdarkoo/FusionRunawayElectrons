clear;

% Collect data
U_loop = importdata('data/loop_voltage_22440.xls');


% Constants
Q = 1.6 * 10^-19;
deltaT = 10^-6;
m0 = 9.10938291 * 10^-31;
R0 = 0.4;
c = 299792458;


% Tunning params
U_loopTreshold = 2;
U_loopSmoothingCoef = 1000;


% Determine number of samples 
nothing = 0;
[sampleN, nothing] = size(U_loop);

% Calculate E
E = U_loop / (2 * pi * R0);
plot(U_loop(:, 1), E)


% Find peaks (begining and the end of the plasma existance)
U_loopSmoothed = smooth(U_loop(:,2), U_loopSmoothingCoef);
U_loopPeakStartValue = 0;
U_loopPeakStartIndex = 0;
U_loopPeakEndValue = 0;
U_loopPeakEndIndex = 0;
for i = 2:sampleN
    if (U_loopSmoothed(i) < U_loopSmoothed(i - 1) && U_loopSmoothed(i) > U_loopTreshold) 
        U_loopPeakStartValue = U_loopSmoothed(i - 1);
        U_loopPeakStartIndex = i;
        break;
    end
end
for i = sampleN:-1:2
    if (U_loopSmoothed(i) > U_loopSmoothed(i - 1) && U_loopSmoothed(i) > U_loopTreshold) 
        U_loopPeakEndValue = U_loopSmoothed(i - 1);
        U_loopPeakEndIndex = i;
        break;
    end
end
subplot(2, 2, 1)
plot(1:sampleN, U_loopSmoothed, U_loopPeakStartIndex, U_loopPeakStartValue, 'ro', U_loopPeakEndIndex, U_loopPeakEndValue, 'ro')
title('U_loop');

% Calculate Velocity
% We are using Newton-Euler algorithm
u_n = 0;
v = 1:(U_loopPeakEndIndex - U_loopPeakStartIndex);
for i = U_loopPeakStartIndex:U_loopPeakEndIndex
    E = U_loop(i, 2) / (2 * pi * R0);
    Etilda = (Q * deltaT * E) / m0;
    u_n = u_n + Etilda;
    v(i - U_loopPeakStartIndex + 1) = u_n / sqrt(1 + u_n^2 / c^2);
end
subplot(2, 2, 3)
plot(U_loop(U_loopPeakStartIndex:U_loopPeakEndIndex, 1), v)
title('Cut velocity (durign plasma lifetime)')


% Calculate energy
E = c * sqrt(m0^2 * c^2 + (m0 * v).^2 ./ (1 + (v/c).^2));
E = E ./ Q;
subplot(2, 2, 4)
plot(U_loop(U_loopPeakStartIndex:U_loopPeakEndIndex, 1), E)
title('Energy of electrons')


% Velocity check
BN = 10000;
v = 1:BN;
u_n = 0;
v(1) = 0;
for i = 2:BN
    Etilda = (Q * deltaT * 5) / m0;
    u_n = v(i-1) / sqrt(1 - (v(i-1)/c)^2);
    
     u_n =u_n + Etilda;
     v(i)=u_n/sqrt(1+(u_n/c)^2);
end

disp(['If ', num2str(v(BN - 1)) ,'~299792458 algorithm is ok'])


