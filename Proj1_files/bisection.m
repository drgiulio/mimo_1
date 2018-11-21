function [x,val,iter,state] = bisection(f_hand,x0,x1,maxit,xtol,ftol,tolopt)
% Bisection search method
%   [x,val,iter,state] = BISECTION(f_hand,x0,x1,maxit,xtol,ftol,tolopt)
% to find the roots of the function
%               f(x) = 0.
% Inputs: 
%       f_hand : function handle f(x)
%       x0     : lower bound (lb)
%       x1     : upper bound (ub)
%       maxit  : maximum number of iterations (optional) 
%                default value is "maxit = 1e6
%       xtol   : tolerance of abs(xlb-xub) (optional)
%                default value is "xtol = 1e-6"
%       ftol   : tolerance of abs(flb-fub) (optional)
%                default value is "xtol = 1e-6"
%       tolopt : option to define which tolerance is relevant
%                    tolopt=='xtol'  =>  xtol is relevant (default)
%                    tolopt=='ftol'  =>  ftol is relevant
%                    tolopt=='all'   =>  xtol and ftol are relevant
%
% Outputs:  output (structure)
%       x    : optimal value of x
%       val  : optimal value of f(x)
%       iter : number of iterations
%       state: reason for exit
%                     'Solved'
%                     'Inaccurate'
%                     'Infeasible'
%                     'Inputs'
%                     'Problem'
%

% Output initialization
x = NaN;
val = NaN;
iter = Inf;
state = 'Problem';

% Input verification
if nargin<3, state = 'Inputs'; return; end
if nargin<4, maxit = 1e3; end
if nargin<5, xtol = 1e-10; end
if nargin<6, ftol = 1e-10; end
if nargin<7, tolopt = 'xtol'; end
if isa(f_hand,'function_handle')~=1, state = 'Inputs'; return; end
if isa(tolopt,'char')~=1, state = 'Inputs'; return; end

% Try bisection method 
% Input initialization
xlb = x0;
xub = x1;
flb=f_hand(x0);
fub=f_hand(x1);
switch tolopt,
  case 'xtol',
    tolerance = @(fun,lb,ub) abs(abs(ub)-abs(lb))>xtol;
  case 'ftol',
    tolerance = @(fun,lb,ub) abs(fun)>ftol;
  case 'all',
    tolerance = @(fun,lb,ub) abs(abs(ub)-abs(lb))>xtol || abs(fun)>ftol;
  otherwise
    state = 'Inputs';
    return;
end

% Check Bounds
if flb*fub>0,
    state = 'Infeasible';
    return;
elseif flb==0,
    state = 'Solved';
    x = xlb;
    val = flb;
    iter = 0;
    return;
elseif fub==0,
    state = 'Solved';
    x = xub;
    val = fub;
    iter = 0;
    return;
end

% Bisection method
xm = (xlb+xub)/2;
fm = f_hand(xm);
iter = 1;
while (iter<maxit) && tolerance(fm,xlb,xub)==1,
    if (flb*fm>0),
        xlb = xm;
        flb = fm;
    elseif (fub*fm>0),
        xub = xm;
        fub = fm;
    elseif fm==0
        x = xm;
        val = f_hand(xm);
        state = 'Solved';
        return;
    else
        state = 'Infeasible';
        return;
    end
    xm = (xlb+xub)/2;
    fm = f_hand(xm);
    iter=iter+1;
end

% Resulting Output
x = xm;
val = f_hand(xm);
if tolerance(fm,xlb,xub)==0,
    state = 'Solved';
elseif iter == maxit,
    state = 'Iteration';
end
