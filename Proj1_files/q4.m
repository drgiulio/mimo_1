clc
clear
close all

% Load channel/system
load('example_channels.mat')

% Compute EVD of H' * C_n^-1 * H
[V, Phi] = eig(H' * (Cn \ H));

% Sort eigenvalues decreasingly
phi = sort(real(diag(Phi)),'descend');

% Compute powers where algorithms switch from K to K+1 active streams
% Uniform allocation
Ptx_K_un = zeros(length(phi)-1,1);
for K = 1:length(phi)-1
    [Ptx_K_un(K),~] = maxpower_Kstreams(phi,K,'uniform_rate');
end
% Waterfilling solution
Ptx_K_wf = activeStreams_waterfilling(phi);