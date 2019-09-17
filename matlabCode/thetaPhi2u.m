function [u] = thetaPhi2u(theta,phi)
    
    
    u = [sin(theta).*cos(phi);...
         sin(theta).*sin(phi);...
         cos(theta).*ones(1,length(phi))];

end