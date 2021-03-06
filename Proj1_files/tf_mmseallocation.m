function [ R ] = tf_mmseallocation( H, Cn, Ptx )
% function [ R ] = tf_mmseallocation( H, Ptx )
%
% MSE optimal power allocation with transmit filter design.
%
% Inputs
% H: Transmission Channel
% Cn: Noise covariance matrix
% Ptx: available sum transmit power Ptx
% Outputs
% R: Achievable rate



% TODO
%{
% Sort eigenvalues of of H' * C_n^-1 * H decreasingly
phi = sort(real(eig(H' * (Cn \ H))),'descend');

% Get number of channel eigenmodes, i.e. number of transmit antennas
N = length(phi);

% Iteration over number of active streams K
for K = 1:N
    % Compute MMSE common 'level' for current K
    mu = (Ptx + sum(1./phi(1:K))) / sum(1./sqrt(phi(1:K)));
    
    % Check if solution is optimal
    if K == N
        break;
    elseif mu/sqrt(phi(K+1)) < 1/phi(K+1)
        break;
    end
end

% Calculate power allocation for K active streams
psi = zeros(size(phi));
psi(1:K) = mu./sqrt(phi(1:K)) - 1./phi(1:K);

% Compute achievable rate
R = sum(log2(1+phi.*psi));
%}

% Compute equalizer constant g
mat_factor = H' * H + trace(Cn) * eye(size(H,2)) / Ptx;
g_abs_squared = trace((mat_factor\  H')  * (H / mat_factor)) / Ptx;
g = sqrt(g_abs_squared);

% Compute precoder
T = (mat_factor \ H') / g;

% Compute achievable rate
R = real(log2(det(eye(size(H,2)) + H' * (Cn \ H) * (T * T'))));