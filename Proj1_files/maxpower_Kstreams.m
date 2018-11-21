function [Ptx_K,state] = maxpower_Kstreams(phi,K,allocation)
% Function [Ptx_K,state] = maxpower_Kstreams(phi,K,allocation)
%
% Measures the maximum power Ptx_K where transmission over K
% streams is optimal in terms of the achievable rate or the MMSE.
% The accuracy of the provided function is 1e-6
%
% Inputs
% phi: vector of eigenmode coefficients phi1,...,phiN
% K  : number of active streams K=1,2,...,N-1
% allocation: string for the power allocation to be used
%             either    'waterfilling'
%             or        'mmseallocation'
%             or        'uniform_rate'
%             or        'uniform_mmse'
% Outputs
% Ptx_K: maximum sum transmit power Ptx for K active streams
% state: state message of the measurement campaign

phi = phi(:);

% determine N
N = length(phi);

% sort phi in descending order
phi_sort = sort(phi,'descend');

% minimal and maximal transmit power for search 
Ptx_min = 1e-10;
Ptx_max_rate = N/phi_sort(end) - sum(1./phi_sort);
Ptx_max_mmse = 1/sqrt(phi_sort(end))*sum(1./sqrt(phi_sort)) - sum(1./phi_sort);
Ptx_max_uniform = 1e6;

% Ptx_max and function handle for the measurement
switch allocation,
  case 'waterfilling',
    Ptx_max = 2*Ptx_max_rate;
    power_handle = @(x) find(sort(waterfilling(phi,x),'descend'),1,'last') - K-0.5;
  case 'mmseallocation',
    Ptx_max = 2*Ptx_max_mmse;
    power_handle = @(x) find(sort(mmseallocation(phi,x),'descend'),1,'last') - K-0.5;
  case 'uniform_rate',
    Ptx_max = 2*Ptx_max_uniform;
    power_handle = @(x) find(sort(uniform_rate(phi,x),'descend'),1,'last') - K-0.5;
  case 'uniform_mmse',
    Ptx_max = 2*Ptx_max_uniform;
    power_handle = @(x) find(sort(uniform_mmse(phi,x),'descend'),1,'last') - K-0.5;
  otherwise,
    Ptx_K = NaN;
    return;
end

% bisection search for finding Ptx_K (maximal 1e3 iterations are performed)
[Ptx_K,~,~,state] = bisection(power_handle,Ptx_min,Ptx_max,1e3,1e-6);
    