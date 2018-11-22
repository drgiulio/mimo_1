function [Psi] = waterfilling_average(lambda, Phi)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Initialize
Psi = zeros(size(Phi));

% Get number of channel eigenmodes, i.e. number of transmit antennas
N = size(Phi,1);

% Number of channel realizations
L = size(Phi,2);

% Compute waterfilling solutions for every realization
for l = 1:L
    Psi(:,l) = waterfilling(sort(real(Phi(:,l)),'descend'), sum(max(zeros(N,1), 1/(log(2)*lambda) - 1./Phi(:,l))));
end

