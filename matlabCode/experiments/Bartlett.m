classdef Bartlett < DOA_estimator 
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        N;
        K; % numer of snapshots
        Fs; % sample rate
        El_index;
        f;       
        lambda;
        thetas;
        ula;
    end
    
    methods (Access=public)
        function obj = Bartlett(N,K,Fs,target_frequency)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.N = N;
            obj.K = K; % numer of snapshots
            obj.Fs = Fs; % sample rate
            obj.El_index = 1:N;
            obj.f = target_frequency;
            obj.lambda = physconst('LightSpeed')/obj.f;
            obj.ula = phased.ULA('NumElements',N,'ElementSpacing',obj.lambda/2);
            obj.El_index = 1:obj.N;
            
            obj.thetas = -90:1:90;
        end
        
        function out = getDOA(obj,angles,data)
            elements = 1:obj.N;
            %getDOA output power per angle data
            %   angles is a 2 x M Matrix incident signal angles. the first
            %   row is azimuth and the second is elevation. M is the number
            %   of incident signals
            %   data is a matrix that is N X M where the columns N are the
            %   samples for each incident signal
            assert(size(angles,2) == size(data,2),"angles and data must be same length. Use different frequencies in data so the signals are noncoherent");
            s = zeros(size(data,1),1);
            for angle=length(angles)
                s = s + collectPlaneWave(obj.ula,data,angles,1e8,physconst('LightSpeed'));
            end
            
            lfft=1024*1;                    % number of data points for FFT in a snapshot
            df = obj.Fs/lfft/1;                 % frequency grid size
            F = 0:df:obj.Fs/1-df;
            for ih=1:obj.N
                 for iv=1:obj.K
                     pos=(iv-1)*lfft+1;
                     tmp=s(pos:pos+lfft-1,ih);
                     X(:,ih,iv)=fft(tmp);
                 end
            end
            
           [mf,mi]=min(abs(F-obj.f));
           f0=F(mi);
           disp(f0);
          for ih=1:obj.N
                for iv=1:obj.K
                    X0(ih,iv)=X(mi,ih,iv);
                end
          end
          FB = obj.FB_average(X0);
          disp(FB);
          R = (1/obj.K)*(X0*X0');

          v = exp(1j*pi*elements.'*cosd(obj.thetas-90));
          v_t = v';

          for i=1:length(obj.thetas)
            outpt(i) =  v_t(i,:)*R*v(:,i);   
          end
          out = abs(outpt)/max(abs(outpt));
        end
        
        function out = FB_average(obj,X)
            % X is a 10x100
            % create J matrix    
            X = 1/sqrt(obj.K)*X;
            I = eye(obj.N);
            J = zeros(size(I));
            for cols = 1:obj.N
                J(:,cols) = I(:,obj.N+1-cols);
            end
            % calculate spectral matrix estimate
            fwd_avg = X*X';
            bkwd_avg = J*conj(X)*X.'*J;
            tempp = (1/2)*(fwd_avg + bkwd_avg);
            out = tempp;
        end
    end
end

