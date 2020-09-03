t = 0:.1:5 * 2 * pi;
s = sin(t);

% signal frequency
f = 1;


% wavelength
lambda = C * 1 / f;

% angle of incidence
theta = 30;
thetas = 0:0.1:180;

% antenna spacing
d = .5 * lambda;

% number of elements
M = 1:5;

% a = exp(1j * M * 2 * pi * d * cost(theta) / lambda) simplifies to:
a = exp(1j* ((pi*cosd(thetas.'))*(M)));

%plot the steering vec values
%axis([0 1])
%ap = [real(a(1,:));imag(a(1,:))];
%plotv(ap,'-');

% recieved signals

x = exp(1j*2*pi*(cosd(theta))*(M));

power = ((a*x.').*conj(a*x.')).^.5;
power2 = sum(a.');
plot(thetas,log10(power))





