function [psi,K] = uniform_rate(phi,Ptx)
% Function [psi,K] = uniform_rate(phi,Ptx)
%
% Rate maximizing uniform power allocation for the given average
% total transmit power constraint sum(psi)<=Ptx.
%
% Inputs
% phi: vector of eigenmode coefficients phi1,...,phiN
% Ptx: available sum transmit power Ptx
% Outputs
% psi: vector of optimal power allocations psi1,...,psiN
% K: number of active data streams K

phi = phi(:);

% TODO

% Get number of channel eigenmodes, i.e. number of transmit antennas
N = length(phi);

% Iteration over number of active streams K
R_K = zeros(size(phi));
for K = 1:N
    % Compute achievable data rate for current K
    R_K(K) = sum(log2(1+Ptx*phi(1:K)/K));
end

% Get optimal K: maximum R_K
[~, K] = max(R_K);

% Compute power allocation uniformly
psi = zeros(size(phi));
psi(1:K) = Ptx/K;