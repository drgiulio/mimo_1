function [ Ptx ] = activeStreams_waterfilling( phi )
% function [ Ptx ] = activeStreams_waterfilling( phi )
%
% Function computes the power values for which the waterfilling power
% allocation switches from K to K+1 active streams
%
% Input:
% phi: vector of eigenmode coefficients phi1,...,phiN
% Output:
% Ptx: vector of power values (size N-1x1) for which the power allocation
% switches from K to K+1 active streams

% TODO

% Get number of channel eigenmodes, i.e. number of transmit antennas
N = length(phi);

% Initialization
Ptx = zeros(N-1,1);

% Iteration over number of active data streams
for K = 1:N-1
    % Compute threshold power value for current K
    Ptx(K) = K/phi(K+1) - sum(1./phi(1:K));
end

end

