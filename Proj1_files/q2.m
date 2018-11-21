clc
clear
close all

% Load channel/system
load('example_channels.mat')

% Compute EVD of H' * C_n^-1 * H
[V, Phi] = eig(H' * (Cn \ H));

% Sort eigenvalues decreasingly
phi = sort(real(diag(Phi)),'descend');

% Compute powers where waterfilling algorithm switches from K to K+1 active
% streams
threshold_Ptx = activeStreams_waterfilling(phi);