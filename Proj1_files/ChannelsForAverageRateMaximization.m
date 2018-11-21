function [H] = ChannelsForAverageRateMaximization(Narr,L)
% function [H] = ChannelsForAverageRateMaximization(Narr,L)
%
% This function generates L random channels for each elemant in Narr, where
% the elements of Narr correspond to the number of transmit and receive 
% antennas of the respective channel.
%
% Input: Narr - Array containing the number of antennas for which random
%               channels are to be generated.
%        L - Number of channels to be generated for each element of Narr
%
% Output: H - Cell array of size 1 x length(Narr).
%             The cell with index ii contains a matrix of size
%             Narr(ii) x Narr(ii) x L with the randomly generated channels.

% Setting seed
rng(3)

H = cell(1,length(Narr));
for ii=1:length(Narr)
    N = Narr(ii);
    H{ii} = 1/sqrt(N*2) * (randn(N,N,L) + 1j*randn(N,N,L));
    for k=1:L
        H{ii}(:,:,k) = H{ii}(:,:,k)*(1-binornd(1,0.2)*0.9);
    end
end

