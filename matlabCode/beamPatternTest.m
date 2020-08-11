
%% Array Element Design
desFreq = 5.21e9;
tarFreq = desFreq * 0.7;
c = 300e6; % Speed of light
desLam = c/desFreq;

% set up microphone arrays distance 
d = desLam/2;
% posVec = [
%     d,  d, -d, -d, 0,  0;
%     d, -d,  d, -d, 0,  0;
%     0,  0,  0,  0, d, -d];


% posVec = [d/2,  -d/2,   d/2,    -d/2;
%           d/2,  d/2,    -d/2,   -d/2;
%           0,    0,      0,      0];

nPhones = 10;
n = 0:nPhones-1;
%posVec = [n*d - mean(n*d); zeros(1,nPhones); zeros(1,nPhones)];
N = nPhones;
posVec = [n*d - mean(n*d), n*d - mean(n*d); ones(1,N), -1*ones(1,N); zeros(1,N), zeros(1,N)];

figure;scatter3(posVec(:,1), posVec(:,2), posVec(:,3));

% posVec(:,end+1) = [0; d; 0];


% posVec = [n*d - mean(n*d); zeros(1,N); zeros(1,N)];
% posVec = [zeros(1,N); zeros(1,N); n*d - mean(n*d)];

%% Looking Direction
thLook = deg2rad(90);
phiLook = deg2rad(90);
angleVec = -180:0.1:180 - 0.1;



%% Steering Matrix and Beam Pattern Slices

[aVec, eVec, dirVec] = genAzEleVecs(thLook, phiLook);


aSteerMat = exp(-1j * 2 * pi * (tarFreq/c) .* (aVec.') * posVec);
eSteerMat = exp(-1j * 2 * pi * (tarFreq/c) .* (eVec.') * posVec);



uLook = thetaPhi2u(thLook, phiLook).';
steerVec = exp(-1j*2*pi* (tarFreq/c) .* uLook * posVec);
steerVec = steerVec/sum(abs(steerVec));


eBeamPattern = eSteerMat * steerVec';
aBeamPattern = aSteerMat * steerVec';



%% Plotting
figure;
subplot(2,2,1)
plot(angleVec, db20(aBeamPattern))
title('Azimuth');

subplot(2,2,3)
plot(angleVec, db20(eBeamPattern))
title('Elevation')

subplot(2,2,2)
quiver3(0,0,0,dirVec(1),dirVec(2),dirVec(3))
hold on;
plot3(eVec(1,:),eVec(2,:),eVec(3,:))
hold on;
plot3(aVec(1,:),aVec(2,:),aVec(3,:))

title('Steering Vector');
legend('DirVec', 'Elevation', 'Azimuth')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
zlim([-1.5 1.5])
xlabel('x')
ylabel('y')

subplot(2,2,4)
scatter3(posVec(1,:),posVec(2,:),posVec(3,:));
title('Microphone Position')
xlabel('x')
ylabel('y')


% figure;
% 
% subplot(1,2,1)
% polarplot(abs(aBeamPattern))
% title('Azimuth')
% 
% subplot(1,2,2)
% polarplot(abs(eBeamPattern))
% title('Elevation')


function [azVec, eleVec, dirVec] = genAzEleVecs(theta, phi)

    dirVec = thetaPhi2u(theta,phi);
    eOrthoVec = cross(dirVec, [0,0,1]); % all elevation sweeps must cross [0,0,1]
    eOrthoVec = eOrthoVec/norm(eOrthoVec);
    aOrthoVec = cross(dirVec, eOrthoVec);
    aOrthoVec = aOrthoVec/norm(aOrthoVec);

    % Generate Angles to sweep across
    %angleVec = deg2rad(-180:.1:180) - (pi - phi);
    angleVec = deg2rad(-180:.1:180-0.1) - (phi);
    %eAngleVec = deg2rad(-180:.1:180);
    
    % generate circle centered out orthogonal vector 
    eleVec = cos(angleVec).*dirVec + sin(angleVec).* (cross(eOrthoVec,dirVec).');
    azVec = cos(angleVec).*dirVec + sin(angleVec).* (cross(aOrthoVec,dirVec).');
    %eleVec = []

end


function [u] = thetaPhi2u(theta,phi)
    
    
    u = [sin(theta).*cos(phi);...
         sin(theta).*sin(phi);...
         cos(theta).*ones(1,length(phi))];

end


