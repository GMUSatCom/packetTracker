Fs = 25e6;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 16384;            % Number of samples
t = (0:L-1)*T;        % Time vector
Fc = 900e6;           % Carrier Frequency

% f = fopen('./testData/Sampe1/s1.txt', 'rb');
f = readmatrix('./testData/Sample1/s1.txt');

iqData = complex(f(:,1),f(:,2));

Y = fftshift(fft(iqData));
dBFS = 20*log10(abs(Y)/2e11);

f = (((-L/2:((L/2)-1))/L)*Fs)+Fc;

plot(f,dBFS) 
ax = gca;
ax.XAxis.Exponent = 6;

xlim([Fc-(Fs/2) Fc+(Fs/2)])
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (MHz)')
ylabel('|Amplitude(dBFS)|')
