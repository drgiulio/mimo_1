function [psi,mu,K] = waterfilling(phi,Ptx)
% Function [psi,mu,K] = waterfilling(phi,Ptx)
%
% Waterfilling power allocation procedure under the total transmit
% power constraint sum(psi)<=Ptx.
%
% Inputs
% phi: vector of eigenmode coefficients phi1,...,phiN
% Ptx: available sum transmit power Ptx
% Outputs
% psi: vector of optimal power allocations psi1,...,psiN
% mu: value of the optimal waterlevel mu^prime
% K: number of active (non-zero) data streams K

phi = phi(:);

% TODO

% Get number of channel eigenmodes, i.e. number of transmit antennas
N = length(phi);

% Iteration over number of active streams K
for K = 1:N
    % Compute waterfilling level for current K
    mu = (Ptx + sum(1./phi(1:K)))/K;
    
    % Check if solution is optimal
    if K == N
        break;
    elseif mu < 1/phi(K+1)
        break;
    end
end

% Calculate power allocation
psi = zeros(size(phi));
psi(1:K) = mu - 1./phi(1:K);