ang1 = [45; 0];          % First signal
ang2 = [-20; 0];         % Second signal
angs = [ang1];
K = 100;
Fs = 50000;
f = 300;
Nsamp = (K+1)*1024;
t = ((0:Nsamp)*1/Fs)';
xm = sin(2*pi*(f)*t);
ym = sin(2*pi*(f)*t);
b = Bartlett(10,K,Fs,f);
plot(b.thetas,b.getDOA(angs,[xm]));



