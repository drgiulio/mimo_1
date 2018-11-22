function [p] = cdf_H_mp_law(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p = 0;
if x > 0
    if x <= 4
        p = (sqrt(x*(4-x)) + 4*asin(sqrt(x)/2)) / (2*pi);
    else
        p = 1;
    end
end
end

