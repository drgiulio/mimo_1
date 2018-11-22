function [phi] = largeSystem(N)
% Function [phi] = largeSystem(N)
%
% Large system approximation of the eigenmodes of H'H,
% where the NxN channel matrix H has i.i.d. circularly 
% symmetric complex Gaussian entries with zero-mean and
% variance 1/N.
%
% Input
% N: number of transmit and receive antennas N
% Output
% phi: vector of channel eigenmodes phi1,...,phiN

% Initialize
phi = zeros(N,1);

% Compute eigenvalues
for k = 1:N
    f_handle = @(x) cdf_H_mp_law(x) - (k-1/2)/N;
    phi(k) = fzero(f_handle, 0);
end

% Sort eigenvalues
phi = sort(phi,'descend');

