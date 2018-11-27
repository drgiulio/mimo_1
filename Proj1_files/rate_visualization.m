clc
clear
%close all
% Script           rate_visualization
%***************************************************************
%
% Visualization of the achievable rates of the considered four
% power allocation strategies for a point-to-point MIMO system.
% Plots the achievable rates versus the transmit power Ptx in dB.
%
%***************************************************************

% System Parameters
N = 4;
Ptx_dB = -20:0.1:30;
no_Ptx = length(Ptx_dB);

% Transmit power calculation
Ptx = 10.^(Ptx_dB/10); % TODO

% Channel and eigenmode coefficients
load('example_channels.mat','H','Cn');
phi = sort(real(eig(H' * (Cn \ H))),'descend'); % TODO

% Initialization of rate arrays
R_waterfilling = zeros(1,no_Ptx);
R_uniform      = zeros(1,no_Ptx);
R_tf_mmse      = zeros(1,no_Ptx);

% Calculation of the achievable rates
for i = 1:no_Ptx
    % Waterfilling
    [psi,~,~] = waterfilling(phi,Ptx(i));
    R_waterfilling(i) = sum(log2(1+phi.*psi));
    
    % Uniform
    [psi,~] = uniform_rate(phi,Ptx(i));
    R_uniform(i) = sum(log2(1+phi.*psi));
    
    % MMSE    
    R_tf_mmse(i) = tf_mmseallocation(H, Cn, Ptx(i));
end

% Calculation of the the transmit powers (in dB) where the number of streams switch from K to K+1
switch_Ptx_waterfilling = zeros(N-1,1);
switch_Ptx_uniform = zeros(N-1,1);
for K = 1:N-1
    % Waterfilling
    switch_Ptx_waterfilling(K) = maxpower_Kstreams(phi,K,'waterfilling');
    % Uniform
    switch_Ptx_uniform(K) = maxpower_Kstreams(phi,K,'uniform_rate');
end


% Calculation of the corresponding rates to the switching powers from K to K+1
switch_R_waterfilling = zeros(N-1,1);
switch_R_uniform = zeros(N-1,1);
for K = 1:N-1
    % Waterfilling
    [psi,~,~] = waterfilling(phi,switch_Ptx_waterfilling(K));
    switch_R_waterfilling(K) = sum(log2(1+phi.*psi));
    
    % Uniform
    [psi,~] = uniform_rate(phi,switch_Ptx_uniform(K));
    switch_R_uniform(K) = sum(log2(1+phi.*psi));
end

% Plotting the achievable rates over Ptx in dB
rate_figure = figure;
hold on;
plot(Ptx_dB,R_waterfilling,'Color','k','LineStyle','-','Marker','none','LineWidth',2);
plot(Ptx_dB,R_uniform,'Color','b','LineStyle','-','Marker','none','LineWidth',2);
plot(Ptx_dB,R_tf_mmse,'Color','m','LineStyle','-','Marker','none','LineWidth',2);
hold off;

% Changing the visualization of the plot
xlabel('Ptx in [dB]');
ylabel('rate in [bits/channel usage]');
%legend(gca,'waterfilling','uniform','TF-MMSE allocation','Location','NorthWest');
grid on;

% Marking the switching points in the plots in the form
% plot(VALUES,VALUES,'Color',COLOR,'LineStyle','none','Marker',MARKER,'LineWidth',2);
% Use the same values for COLOR as are used for plotting the lines.
% Use the following values for MARKER: 
%        'o' for waterfilling
%        's' for mmse
hold on;
% TODO
plot(10*log10(switch_Ptx_waterfilling),switch_R_waterfilling,'Color','k','LineStyle','none','Marker','o','LineWidth',2);
plot(10*log10(switch_Ptx_uniform),switch_R_uniform,'Color','b','LineStyle','none','Marker','o','LineWidth',2);
hold off;

legend(gca,'waterfilling','uniform','TF-MMSE allocation','waterfilling stream increment points','uniform stream increment points','Location','NorthWest');