N = 20;
K = 100; % numer of snapshots
Fs = 50000; % sample rate

elements = 1:N;
% w = ones(1,N).';
% s = exp(1i*2*pi*1/8);
% xn = exp(1i*2*pi*3/8);
tarFreq = 3000;
desFreq = 3000;
carrFreq = 3000;
% cf = 1e6;

% lambda = physconst('LightSpeed')/tarFreq;
% a = exp(1j*pi*elements*cosd(50)).';
% x = s * w' *a + w'*xn;

lambda = physconst('LightSpeed')/desFreq;
ula = phased.ULA('NumElements',N,'ElementSpacing',lambda/2);
ang1 = [45; 0];          % First signal
ang2 = [-20; 0];         % Second signal
angs = [ang1 ];
Nsamp = (K+1)*1024;
t = ((0:Nsamp)*1/Fs)';

% xm = sin(2*pi*(tarFreq)*t);
xm = chirp(t, 0, max(t),tarFreq);

s = collectPlaneWave(ula,xm,ang1,carrFreq,physconst('LightSpeed'));

posVec = getElementPosition(ula);


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

% data = fft(X(1:lfft,5));
% P1 = data(1:lfft/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% x_axis = Fs*(0:lfft/2)/lfft;
% % plot(t(1:(50)),s(1:(50),1));
% plot(x_axis,P1);

[mf,mi]=min(abs(freqVec-tarFreq));
f0=freqVec(mi);

%{
for ih=1:N
    for iv=1:K
        X0(ih,iv)=X(mi,ih,iv);
    end
end


for ih=1:N
    for iv=1:K
        Y0(ih,iv)=Y(mi,ih,iv);
    end
end

%}


%% Narrow Band on Design Frequency 
X0 = squeeze(X(mi, :,:));
Y0 = squeeze(Y(mi, :, :));

R = (1/sqrt(K))*(X0*X0');

thetas = -90:90; 
v = exp(1j*pi*elements.'*cosd(thetas-90));
v_t = v';

for i=1:length(thetas)
    bartOut(i) =  v_t(i,:)*R*v(:,i);   
end
invR = R^(-1);
for i=1:length(thetas)
    caponOut(i) =  1/(v_t(i,:)*invR*v(:,i));   
end

plot(thetas,db20(bartOut)/max(db20(bartOut)));
hold on 
plot(thetas,db20(caponOut)/max(db20(caponOut)));
hold off
legend('bartlett','capon')


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




% figure;plot(thetas, db20(mean(caponOutNew, 1)))


%% Extra functions 
function outData = db20(inData)

   outData = 20*log10(abs(inData)); 

end

% exp(-1j * 2 * pi * (freqVec(ff)/c) .* delayVec);
function [steerOut] = genSteer(freqVal, const, uVec, posVec)

    steerOut = exp( -1j * 2 * pi * (freqVal/const) * uVec.' * posVec);

end 
% 
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


function outVec = eleAz2u(eleVec, azVec)

    xx = cos(eleVec) .* cos(azVec);
    yy = cos(eleVec) .* sin(azVec);
    zz = ones(size(xx)) .* sin(eleVec);
    
    outVec = [xx;yy;zz];


end




