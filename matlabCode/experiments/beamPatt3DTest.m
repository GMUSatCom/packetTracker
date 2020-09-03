close all;
clear;
n = 0:9;
N = length(n);
desFreq = 5.21e9;
tarFreq = desFreq * 0.7;
c = 300e6; % Speed of light
desLam = c/desFreq;

% set up microphone arrays distance 
d = desLam/2;

posVec = [n*d - mean(n*d), n*d - mean(n*d); ones(1,N), -1*ones(1,N); zeros(1,N), zeros(1,N)];

nPhones = length(posVec);
% posVec = [zeros(1,N); zeros(1,N); n*d - mean(n*d)];q
thLook = deg2rad(90);
phiLook = deg2rad(90);


nPt = 300;
thLinVec = linspace(0, pi, nPt);
phiLinVec = linspace(0, 2*pi, nPt);

[thMat, phiMat] = meshgrid(thLinVec, phiLinVec);
thVec = thMat(:).';
phiVec = phiMat(:).';
uVec = thetaPhi2u(thVec, phiVec);

steerMat = exp(-1j * 2 * pi * (tarFreq/c) .* (uVec.') * posVec);
steerVec = exp(-1j * 2 * pi * (tarFreq/c) .* (uVec.') * posVec
% steerVec = exp(-1j * 2 * pi * (tarFreq/c) .* cos(phiLook) * n * d);
steerVec = steerVec/sum(abs(steerVec));

beamPattern = steerMat * steerVec';
beamPattern = reshape(beamPattern, nPt, nPt);

minPow = -40;
dbBeamPattern = db20(beamPattern);

dbBeamPattern(dbBeamPattern < -40) = NaN;
dbBeamPattern = dbBeamPattern + abs(minPow);


[xCart, yCart, zCart] = sph2cart(thMat, phiMat, dbBeamPattern);


plotFig = figure;
plotFig.Position(3) = 2*plotFig.Position(3);


subplot(1,2,1)
bpMesh = surf(xCart, yCart, zCart);colormap(jet);
bpMesh.CData = db20(beamPattern);
caxis([minPow, 0]);
shading interp;
colormap(jet);
colorbar;
title('Beam Pattern');
xlabel('x');
ylabel('y');


eleAx = subplot(1,2,2);
scatter3(posVec(1,:), posVec(2,:), posVec(3,:));
ogXlim = eleAx.XLim;
ogYlim = eleAx.YLim;
ogZlim = eleAx.ZLim;
hold on
dirVec = thetaPhi2u(thLook, phiLook);
quiver3(0,0,0,dirVec(1), dirVec(2), dirVec(3));
title('Array Position');
xlabel('x');
ylabel('y');


eleAx.XLim = ogXlim;
eleAx.YLim = ogYlim;
eleAx.ZLim = ogZlim;

% figure;scatter3(scaledData(1,:), scaledData(2,:), scaledData(3,:));
% bpTri = delaunay(uVec(1,:), uVec(2,:));
% figure;trisurf(bpTri, uVec(1,:), uVec(2,:), uVec(3,:));

% figure;imagesc(rad2deg(thLinVec), rad2deg(phiLinVec), db20(beamPattern));
% colorbar;colormap(jet);














