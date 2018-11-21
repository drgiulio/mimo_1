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