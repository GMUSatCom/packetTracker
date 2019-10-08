f = fopen('rawIQData', 'rb');
iqData = fread (f, [2,Inf], 'float');
fclose(f);
cData1 = (iqData(1,:) + 1j * iqData(2,:));
cData1 = cData1(2e6:4e6);

f = fopen('rawIQData2', 'rb');
iqData = fread (f, [2,Inf], 'float');
fclose(f);
cData2 = (iqData(1,:) + 1j * iqData(2,:));
cData2 = cData2(2e6:4e6);







