function [averageRate,powers] = averageRate_averagePtx(Phi,averagePtx)
% Function [averageRate,powers] = averageRate_averagePtx(Phi,averagePtx)
%
% Average rate maximization with an average transmit power constraints 
% for L channel realizations.
%
% Inputs
% Phi: N x L matrix of eigenmode coefficients phi11,...,phiNL
% averagePtx: available average sum transmit power averagePtx
% Outputs
% averageRate: maximum average achievable rate R
% powers: vector of used transmit power per channel realization Ptx1,...PtxL

% TODO

% bisection search for optimal lambda
lambda_handle = @(x) mean(sum(waterfilling_average(x, Phi), 1)) - averagePtx;
lmin = 1e-3;
lmax = 1e3;
maxit = 1e3;
xtol = 1e-6;
[lambda,~,~,~] = bisection(lambda_handle,lmin,lmax,maxit,xtol);

% Compute maximum average achievable rate
max_log_args = max(ones(size(Phi)), Phi./(log(2)*lambda));
rates = sum(log2(max_log_args), 1);
averageRate = mean(rates); 

% Compute used transmit powers per channel realization
Psi = max(zeros(size(Phi)), 1/(log(2)*lambda) - 1./Phi);
powers = sum(Psi, 1);