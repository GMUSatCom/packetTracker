classdef (Abstract=true) DOA_estimator
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        N;
        K; % numer of snapshots
        Fs; % sample rate
        El_index;
        f;       
        lambda;
        thetas;
    end
    
    methods (Abstract)
       %getBeamPattern(obj,inputArg)
       getDOA(obj)
    end
end

