% Script                averageRateMaximization
%************************************************************
%
% Average Rate maximization of a Gaussian MIMO Point-to-Point System.
%
% System Parameters
% Narr      : array for the number of transmit antennas
% L         : scalar number of Monte-Carlo channel realizations
% meanPtx_dB: vector of the evaluated average transmit powers meanPtx1,...,meanPtxM
% 
% Achieved Average Rates
% meanRate_averagePtx: average rate for the average power constraint
% meanRate_perchanPtx: average rate for the per channel power constraints
%
%*************************************************************

% System Parameters
Narr = [2,4,8,16];
no_Narr = length(Narr);
L = 10000;
meanPtx_dB = -10:2:20;
no_Ptx = length(meanPtx_dB);

% Generate random channels
Hcell = ChannelsForAverageRateMaximization(Narr,L);

% Transmit Power
meanPtx = 10.^(meanPtx_dB./10);

% Achievable Average Rates Calculation for all Channel Konfigurations
meanRate_averagePtx = zeros(no_Narr,no_Ptx);
meanRate_perchanPtx = zeros(no_Narr,no_Ptx);
meanRate_largeN = zeros(no_Narr,no_Ptx);

for n=1:no_Narr % loop for antenna number
    N = Narr(n);
    
    % Load channels from cell
    H = Hcell{n};

    % Channel Eigenmode Calculation
    Phi = NaN(N,L);
    for no=1:L
        Phi(:,no) = real(eig(H(:,:,no)'*H(:,:,no)));
        % sort
        Phi(:,no) = sort(real(Phi(:,no)),'descend');
    end
    
    % Large system approximation
    phi_ls = largeSystem(N);

    % Achievable Average Rates for the Channel Realizations 
    for no=1:no_Ptx
        % Rates and Power allocations for instantaneous transmit power
        [meanRate_perchanPtx(n,no)] = averageRate_perchannelPtx(Phi,meanPtx(no));
        % Rates and Power allocations for average transmit power
        [meanRate_averagePtx(n,no),~] = averageRate_averagePtx(Phi,meanPtx(no));
        % Include large system computation
        [psi_ls,~,~] = waterfilling(phi_ls,meanPtx(no));
        meanRate_largeN(n,no) = sum(max(log2(ones(size(phi_ls)) + phi_ls.*psi_ls), 0));
    end

end

% Create Plots for the Achievable Average Rates
averageRate_figure = figure;
hold on;
for n=1:no_Narr
    plot(meanPtx_dB,meanRate_perchanPtx(n,:),...
         'Color','b','LineStyle','-','Marker','none','LineWidth',2);
    plot(meanPtx_dB,meanRate_averagePtx(n,:),...
         'Color','r','LineStyle','--','Marker','none','LineWidth',2);
    plot(meanPtx_dB,meanRate_largeN(n,:),...
         'Color','g','LineStyle','--','Marker','none','LineWidth',2);
end
hold off;


% Change Visualization of the Plots
xlabel('average Ptx in [dB]');
ylabel('average rate in [bits/channel usage]');
legend(gca,...
       'per channel power constraint',...
       'average power constraint',...
       'large system approximation',...
       'Location','NorthWest');
for n=1:no_Narr
    text(meanPtx_dB(end-2),meanRate_perchanPtx(n,end-2),...
         ['\leftarrow N=',num2str(Narr(n))],...
         'HorizontalAlignment','left',...
         'VerticalAlignment','cap');
end
grid on;