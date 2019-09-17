% db10.m
% 
% finds 10*log10(abs(data)) for amplitude data

function [dbData] = db10(inputData)

    dbData = 10*log10(abs(inputData));

end

