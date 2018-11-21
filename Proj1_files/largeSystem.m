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

