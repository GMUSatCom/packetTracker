
tar_samps = 7e5:7.1e5;

f = fopen('channelA_end.dat', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData1 = (iqData(1,:) + 1j * iqData(2,:));
cData1 = cData1(tar_samps);
cData1 = cData1 - mean(cData1);
cData1 = cData1/std(cData1);


f = fopen('channelB_end.dat', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData2 = (iqData(1,:) + 1j * iqData(2,:));
cData2 = cData2(tar_samps);
cData2 = cData2 - mean(cData2);
cData2 = cData2/std(cData2);


pData = [cData1.' , cData2.'];

centerFreq = 915.5e6;
fs      = 2e6;
c       = 300e6;
d       = 0.165;
nPhones = 2;
n       = 0:nPhones-1;
posVec  = [n*d - mean(n*d); zeros(1,nPhones); zeros(1,nPhones)];
% freqVec = linspace(centerFreq-fs/2,centerFreq+fs/2,nfft).';

phiVec  = deg2rad(-180:180);
aVec    = thetaPhi2u(deg2rad(90), phiVec);


winSize = 50;
nOlap = 25;
nfft = winSize * 2;
[spec1, freqVec, tt] = spectrogram(cData1, winSize, nOlap, nfft, fs);
[spec2]              = spectrogram(cData2, winSize, nOlap, nfft, fs);


delayVec = aVec.' * posVec;
diagLoad = 0;

beamFreq = nan(length(delayVec), length(freqVec));

for ff = 1:length(freqVec)
    
    snapData = [spec1(ff,:); spec2(ff,:)];
    
    covarMat = (snapData * snapData')./length(snapData);
    
    covarMat = covarMat + diagLoad.* eye(size(covarMat));
    
    steerVec        = exp(-1j * 2 * pi * (freqVec(ff)/c) .* delayVec);
    
    
    for bb = 1:length(delayVec)
        steerBeam = steerVec(bb,:).';
        matDiv = covarMat\steerBeam;
        weightsMVDR = matDiv./ steerBeam' * matDiv;
        
        beamFreq(bb,ff) = mean(weightsMVDR' * snapData,2);
        
    end
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