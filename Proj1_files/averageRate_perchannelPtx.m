function [averageRate] = averageRate_perchannelPtx(Phi,averagePtx)
% Function [averageRate] = averageRate_averagePtx(Phi,averagePtx)
%
% Average rate maximization with a per channel transmit power constraints 
% for L channel realizations.
%
% Inputs
% Phi: N x L matrix of eigenmode coefficients phi11,...,phiNL
% averagePtx: available transmit power per channel realization
% Outputs
% averageRate: maximum average achievable rate R

% TODO

% Number of channel realizations
L = size(Phi,2);

% Initialize
Psi = zeros(size(Phi));
K = zeros(1,L);

% Compute waterfilling solution for every channel realization
for l = 1:L
    % compute solution
    [Psi(:,l),~,K(l)] = waterfilling(Phi(:,l),averagePtx);
end

% Compute average achievable rate
%{
rates = zeros(1,L);
for l = 1:L
    for k = 1:K(l)
        rates(l) = rates(l) + max(log2(Phi(k,l)*(averagePtx+sum(Phi(1:K(l),l)))/K(l)), 0);
    end
end
%}
log_args = ones(size(Phi)) + Phi.*Psi;
rates = sum(max(log2(log_args), 0), 1);
averageRate = mean(rates);