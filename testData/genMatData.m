


f = fopen(filename, 'rb');
v = fread (f, count, 'float');
t = fread (f, [2, count], 'float');
v = t(1,:) + t(2,:)*i;
[r, c] = size (v);
v = reshape (v, c, r);