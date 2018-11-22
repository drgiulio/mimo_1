% Script                CDFplot_perChannelPtx.m
%************************************************************
%
% Plots the empirical cumulative distribution function of the p  Average 
% Rate maximization of a Gaussian MIMO Point-to-Point System.
%
% System Parameters
% Narr      : array for the number of transmit antennas
% L         : scalar number of Monte-Carlo channel realizations
% meanPtx_dB: vector of the evaluated average transmit powers meanPtx1,...,meanPtxM
% 
% Internal Variables
% meanPtx: average power limitation (not in dB)
% Ptx: array of per channel powers from the average rate maximization solution
%
%*************************************************************

% System Parameters
Narr = [2,4,8,16];
no_N = length(Narr);
L = 10000;
meanPtx_dB = 10;

% Transmit Power Calculation
meanPtx = 10^(meanPtx_dB/10);% ToDo

% Per Channel Transmit Power Calculation
Ptx = zeros(L,no_N);

% Generate random channels
Hcell = ChannelsForAverageRateMaximization(Narr,L);

for n=1:no_N % loop for antenna number
    N = Narr(n);
    H = Hcell{n};
    
    % Channel Eigenmode Calculation
    Phi = NaN(N,L);
    for no=1:L
        % Load channels from file
        Phi(:,no) = real(eig(H(:,:,no)'*H(:,:,no)));
    end

    % Per Channel Transmit Powers for Average Power Constraint
    % ToDo
    [~, powers] = averageRate_averagePtx(Phi, meanPtx);
    Ptx(:,n) = transpose(powers);
end

% Create empirical CDF Plots for the per Channel Transmit Powers
cdfplot_Ptx = figure;
colors = {'c','k','b','r','g'};
linestyle = {'--','-'};
hold on;
for n=1:no_N
    N = Narr(n);
    h = cdfplot(Ptx(:,n));
    set(h,'DisplayName',['N=',num2str(N)],...
          'Color',colors{mod(n,length(colors))+1},...
          'LineStyle',linestyle{mod(n,length(linestyle))+1},...
          'Marker','none',...
          'LineWidth',2);
end
hold off;


% Change Visualization of the Plots
xlabel('Ptx');
ylabel('empirical CDF of Ptx');
legend(gca,'show','Location','NorthWest');
grid on;