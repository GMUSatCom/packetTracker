f = fopen('rawIQData', 'rb');
iqData = fread (f, [2,Inf], 'float');
fclose(f);
cData = iqData(1,:) + 1j * iqData(2,:);
