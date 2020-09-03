fc = 1e9;
N = 10;
K = 100;
lambda = physconst('LightSpeed')/fc;
%antenna = phased.IsotropicAntennaElement('FrequencyRange',[8e8 1.2e9]);
array = phased.ULA('NumElements',N,'ElementSpacing',lambda/2);
waveform = phased.LinearFMWaveform('SweepBandwidth',200e3,...
    'PulseWidth',1e-3,'OutputFormat','Samples','NumSamples',1024*(K+1),'PRF',1e3);

Fs = 1e6;
sig1 = waveform();
% nsamp = size(sig1,1);
% t = [0:(nsamp-1)]/Fs;
% % plot(t(1:200)*1e6,real(sig1(1:200)))
% nfft = 2^nextpow2(1024);
% Z = fft(sig1,1024);
% fr = [0:(nfft/2-1)]/nfft*Fs;
% plot(fr/1000,abs(Z(1:nfft/2)),'.-')
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% grid
% 
% nfft1 = 64;
% nov = floor(0.5*nfft1);
% spectrogram(sig1(1:2048),hamming(nfft1),nov,nfft1,Fs,'centered','yaxis')

sig2 = sig1;
sig3 = sig1;
ang1 = [30; 0];
ang2 = [60;0];
ang3 = [-50;0];
arraysig = collectPlaneWave(array,[sig1 sig2 sig3],[ang1 ang2 ang3],fc);
% rng default
npower = 0.01;
noise = sqrt(npower/2)*...
    (randn(size(arraysig)) + 1i*randn(size(arraysig)));

rxsig = arraysig + 10*noise;
% figure(1)
% estimator = phased.MUSICEstimator('SensorArray',array,...
%     'OperatingFrequency',fc,'ScanAngles',-70:90,...
%     'DOAOutputPort',true,'NumSignalsSource','Property','NumSignals',2);
% [y,sigang] = estimator(rxsig);
% disp(sigang)
% plotSpectrum(estimator,'NormalizeResponse',true);


figure(2)
lfft=1024*1;                    % number of data points for FFT in a snapshot
df = Fs/lfft/1;                 % frequency grid size
F = 0:df:Fs/1-df;
for ih=1:N
    for iv=1:K
        pos=(iv-1)*lfft+1;
        tmp=rxsig(pos:pos+lfft-1,ih);
        X(:,ih,iv)=fft(tmp);
    end
end
[H,inds] = sort(abs(X(:,1,1)));
highest5 = inds(end-5:end);
bfreq = F(highest5); % frequencies to be beamformed are the ones with the highest power.
% [mf,mi]=min(abs(F-));
% f0=F(mi);
% disp(f0);
for ih=1:N
    for iv=1:K
        for ifr=1:5
            X0(ih,iv,ifr)=X(highest5(ifr),ih,iv);
        end
    end
end
FB = FB_average(X0(:,:,1),K,N);
% R = (1/K)*(X0(:,:,1)*X0(:,:,1)');
[V,D] = eig(FB);
[d,ind] = sort(diag(D));
NS = N-1;
Un = zeros(10,NS);
for i=1:NS
     Un(:,i)=V(:,ind(i));
end
thetas = -70:1:90;
P = zeros(length(thetas),1);
for ti=1:length(thetas)
    a = exp(1j*pi*(1:N).'*cosd(thetas(ti)-90))';
    b = (a*Un)*(a*Un)';
    P(ti) = 1/(b);  
end
plot(thetas,P/max(P));

function out = FB_average(X,K,N)
            % X is a 10x100
            % create J matrix    
            X = 1/sqrt(K)*X;
            I = eye(N);
            J = zeros(size(I));
            for cols = 1:N
                J(:,cols) = I(:,N+1-cols);
            end
            % calculate spectral matrix estimate
            fwd_avg = X*X';
            bkwd_avg = J*conj(X)*X.'*J;
            tempp = (1/2)*(fwd_avg + bkwd_avg);
            out = tempp;
end
