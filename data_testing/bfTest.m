
tar_samps = 7e5:8e5;

f = fopen('channelA_end.dat', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData1 = (iqData(1,:) + 1j * iqData(2,:));
cData1 = cData1(tar_samps);



f = fopen('channelB_end.dat', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData2 = (iqData(1,:) + 1j * iqData(2,:));
cData2 = cData2(tar_samps);

pData = [cData1.' , cData2.'];

centerFreq = 915.5e6;
fs      = 2e6;
nfft    = length(cData2)*2;
c       = 300e6;
d       = 0.165;
nPhones = 2;
n       = 0:nPhones-1;
posVec  = [n*d - mean(n*d); zeros(1,nPhones); zeros(1,nPhones)];
% freqVec = linspace(centerFreq-fs/2,centerFreq+fs/2,nfft).';
freqVec = linspace(0, fs, nfft);

phiVec  = deg2rad(-180:180);
aVec    = thetaPhi2u(deg2rad(90), phiVec);


ftData = fft(pData,nfft,1);
% steerVec    = exp(-1j * 2 * pi * (freqVec.'/c) .* (aVec.') * posVec);
% aa = aVec.' * posVec;
% steerVecAll = exp(-1j * 2 * pi * (freqVec/c) .* aa);
delayVec = aVec.' * posVec;


for ff = 1:length(freqVec)
%     steerVec        = exp(-1j * 2 * pi * (freqVec(ff)/c) .* (aVec.') * posVec);
    steerVec        = exp(-1j * 2 * pi * (freqVec(ff)/c) .* delayVec);
    beamFreq(:,ff)  = ftData(ff,:) * steerVec';
end

%
figure;plot(rad2deg(phiVec), db20(mean(beamFreq,2)));

% figure;imagescc(freqVec, rad2deg(phiVec), db20(beamFreq));
% figure;plot(freqVec, db20(ftData(:,1)));



function [u] = thetaPhi2u(theta,phi)
    
    
    u = [sin(theta).*cos(phi);...
         sin(theta).*sin(phi);...
         cos(theta).*ones(1,length(phi))];

end