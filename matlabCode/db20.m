% db20.m
% 
% finds 20*log10(abs(data)) for amplitude data

function [dbData] = db20(inputData)

    dbData = 20*log10(abs(inputData));

end

