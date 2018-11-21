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