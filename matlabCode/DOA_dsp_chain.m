N = 50;
K = 100; % numer of snapshots
Fs = 3*(2.4e9); % sample rate

elements = 1:N;
% w = ones(1,N).';
% s = exp(1i*2*pi*1/8);
% xn = exp(1i*2*pi*3/8);

desFreq = 2.4e9;            % Frequency array is designed for 
carrFreq = 2.4e9;           % Carrier Frequency 
txFreq= carrFreq - .1e9;    % Frequency of transmitted CW
tarFreq = txFreq;           % Frqeuency to baseband data 
bandWdith = 100e6;
% cf = 1e6;

% lambda = physconst('LightSpeed')/tarFreq;
% a = exp(1j*pi*elements*cosd(50)).';
% x = s * w' *a + w'*xn;

lambda = physconst('LightSpeed')/desFreq;
ula = phased.ULA('NumElements',N,'ElementSpacing',lambda/2);
posVec = getElementPosition(ula);
 


ang1 = [45; 0];          % First signal
ang2 = [20; 0];         % Second signal
ang3 = [90; 0];
angs = [ang1 ang2 ang3];
Nsamp = (K+1)*1024;
t = ((0:Nsamp)*1/Fs)';

% xm = exp(1j* 2*pi*(tarFreq)*t);
% initFreq = txFreq/2;
% finFreq = txFreq;
% txLen = 
% xm = exp(1j * 2 * pi * ())

xm = cos(2*pi*tarFreq*t);
% xm = chirp(t, (9/10)*tarFreq, max(t),tarFreq);
xx = xm + randn(size(xm));
xx = [xx,xx,xx];
s = collectPlaneWave(ula,xx,angs,carrFreq,physconst('LightSpeed'));


%% Baseband 

baseBandVec = exp(-1j * 2 * tarFreq * t);



%% Filter 


%% Decimate 




lfft=1024*1;                    % number of data points for FFT in a snapshot
df = Fs/lfft/1;                 % frequency grid size
freqVec = 0:df:Fs/1-df;


%% Generates Snap Shots
for ih=1:N
    for iv=1:K
        pos=(iv-1)*lfft+1;
        tmp=s(pos:pos+lfft-1,ih);
        X(:,ih,iv)=fft(tmp);
        Y(:,ih,iv)=ifft(tmp);
    end
end

%{
% data = fft(X(1:lfft,5));
% P1 = data(1:lfft/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% x_axis = Fs*(0:lfft/2)/lfft;
% % plot(t(1:(50)),s(1:(50),1));
% plot(x_axis,P1);
%}

%% Narrow Band on Design Frequency 

[mf,mi]=min(abs(freqVec-desFreq));
X0 = squeeze(X(mi, :,:));
Y0 = squeeze(Y(mi, :, :));

R = (1/sqrt(K))*(X0*X0');

% thetas = -90:90; 
thetas = 0:180;
v = exp(1j*pi*elements.'*cosd(thetas-90));
v_t = v';

for i=1:length(thetas)
    bartOut(i) =  v_t(i,:)*R*v(:,i);   
end
invR = R^(-1);
for i=1:length(thetas)
    caponOut(i) =  1/(v_t(i,:)*invR*v(:,i));   
end

figure;
plot(thetas,db20(bartOut)/max(db20(bartOut)));
hold on 
plot(thetas,db20(caponOut)/max(db20(caponOut)));
hold off
legend('bartlett','capon', 'Location', 'best');title('target frqeuency')

[mf,mi]=min(abs(freqVec-txFreq));
X0 = squeeze(X(mi, :,:));
Y0 = squeeze(Y(mi, :, :));

R = (1/sqrt(K))*(X0*X0');

v = exp(1j*pi*elements.'*cosd(thetas-90));
v_t = v';

for i=1:length(thetas)
    bartOut(i) =  v_t(i,:)*R*v(:,i);   
end
invR = R^(-1);
for i=1:length(thetas)
    caponOut(i) =  1/(v_t(i,:)*invR*v(:,i));   
end

figure;
plot(thetas,db20(bartOut./max(abs(bartOut))));
hold on 
plot(thetas,db20(caponOut./max(abs(caponOut))));
hold off
legend('bartlett','capon', 'Location', 'best');title('Design frequency')


%% Broad Band

uVec = eleAz2u(0, deg2rad(thetas-180));
% angleVec = [xData; yData; zData];



for ff = 1:length(freqVec)

    freqVal  = freqVec(ff); 
    steerVec = genSteer(freqVal, physconst('LightSpeed'), uVec, posVec).';
    steerVecHer = steerVec';
    
    snapShots = squeeze(X(ff, :,:));

    covarMat = (1/sqrt(K))*(snapShots*snapShots');

    
    for i=1:length(thetas)
        bartOutNew(ff, i) =  steerVecHer(i,:)*covarMat*steerVec(:,i);   
    end
    invCovarMat = covarMat^(-1);
    for i=1:length(thetas)
        caponOutNew(ff, i) =  1/(steerVecHer(i,:)*invCovarMat*steerVec(:,i));   
    end
    
end 
    
    
% figure;
% imagesc(freqVec, thetas, db20(bartOutNew)/max(db20(bartOutNew)));

figure;
imagesc(thetas, freqVec, db20(bartOutNew./max(abs(bartOutNew(:)))));colorbar;
xlabel('beam');ylabel('frequency');title('Bartlett');
set(gca, 'YDir','normal');caxis('auto');colormap('jet');


figure;
imagesc(thetas, freqVec, db20(caponOutNew./max(abs(caponOutNew(:)))));colorbar;
xlabel('beam');ylabel('frequency');title('Capon');
set(gca, 'YDir','normal');caxis('auto');colormap('jet');



%% Conventional Beamformer 

nfft = size(s, 1);
newFreqVec = linspace(0, 2*Fs, nfft);
ftData = fft(s, nfft,1);

for ff = 1:length(newFreqVec)

    cbfSteerVec = genSteer(newFreqVec(ff), physconst('LightSpeed'), uVec, posVec);
    beamFreq(:,ff) = ftData(ff,:) * cbfSteerVec';
    
end

beamFreq = beamFreq.';



figure;
imagesc(thetas, newFreqVec, db20(beamFreq./max(abs(beamFreq(:)))));colorbar;
xlabel('beam');ylabel('frequency');title('CBF');
set(gca, 'YDir','normal');caxis('auto');colormap('jet');


[~,tarSamp]=min(abs(newFreqVec-txFreq));
[~,desSamp]=min(abs(newFreqVec-desFreq));


tarFreqData = beamFreq(tarSamp, :);
desFreqData = beamFreq(desSamp, :);



figure; hold on
title('CBF')
plot(thetas, db20(tarFreqData./max(abs(tarFreqData))));
xlabel('beam');ylabel('dB');
plot(thetas, db20(desFreqData./max(abs(desFreqData))));
xlabel('beam');ylabel('dB');
legend('Target Frqeuency', 'Design Frequency', 'Location', 'best');



% figure;plot(thetas, db20(mean(caponOutNew, 1)))


%% Extra functions 
function outData = db20(inData)

   outData = 20*log10(abs(inData)); 

end

% exp(-1j * 2 * pi * (freqVec(ff)/c) .* delayVec);
function [steerOut] = genSteer(freqVal, const, uVec, posVec)

    steerOut = exp( -1j * 2 * pi * (freqVal/const) * uVec.' * posVec);

end 


%{ 
% function steerOut = genSteerFast(freqVal, const, delayVec)
% 
%     steerOut = exp(-1j * 2 * pi * (freqVal/const) * delayVec);
% 
% end


% function imageHandle = imagescc(xData, yData, theData)
% 
%     imageHandle = imagesc(xData, yData, flipud(theData));
%     set(gca,'YDir','normal');
% 
% end
%}

function outVec = eleAz2u(eleVec, azVec)

    xx = cos(eleVec) .* cos(azVec);
    yy = cos(eleVec) .* sin(azVec);
    zz = ones(size(xx)) .* sin(eleVec);
    
    outVec = [xx;yy;zz];


end




