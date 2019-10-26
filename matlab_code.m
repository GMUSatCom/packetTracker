f = fopen('./testData/rawIQData', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData1 = (iqData(1,:) + 1j * iqData(2,:));
cData1 = cData1(2e6:2.75e6);
% cData1 = cData1(6e5:7e5);


f = fopen('./testData/rawIQData2', 'rb');
iqData = fread (f, [2,Inf], 'double');
fclose(f);
cData2 = (iqData(1,:) + 1j * iqData(2,:));
cData2 = cData2(2e6:2.75e6);
% cData2 = cData2(6e5:7e5);


cSpeed = physconst('LightSpeed');
nPhones = 2;
nVec = 0:nPhones-1;
tarFreq = 915e6;
d = .163;

thLook = (-90:1:90).';
lambda = cSpeed/tarFreq;


uVec = (d * sind(thLook))/lambda;



phoneData = [cData1; cData2];
steerVec = exp(-1j*2*pi*uVec*nVec);

% ftPhoneData = fft(phoneData);
% 
% bpOut = steerVec' * ftPhoneData;
% 
% 
% figure;imagesc(thLook, [], db20(bpOut.'));colorbar;