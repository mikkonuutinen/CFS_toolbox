function M = create_noise_dead_leaves(sigma_n,shape)

% compute_dead_leaves_image - compute a random image using the dead-leaves model
%
%   M = compute_dead_leaves_image(sigma,shape);
%
%   sigma>0 control the repartition of the size of the basic shape:
%       sigma --> 0  gives more uniform repartition of shape
%       sigma=3 gives a nearly scale invariant image.
%
% References : 
%   Dead leaves correct simulation :
%    http://www.warwick.ac.uk/statsdept/staff/WSK/dead.html
%
%   Mathematical analysis
%    The dead leaves model : general results and limits at small scales
%    Yann Gousseau, Francois Roueff, Preprint 2003
%
%   Scale invariance in the case sigma=3
%    Occlusion Models for Natural Images: A Statistical Study of a Scale-Invariant Dead Leaves Model
%     Lee, Mumford and Huang, IJCV 2003.
%
%   Copyright (c) 2005 Gabriel Peyr

n = 500; % image size
rmin = 0.01;    % maximum proba for rmin, shoult be >0
rmax = 1;    % maximum proba for rmin, shoult be >0
nbr_iter = 5000;

M = zeros(n)+Inf;

x = linspace(0,1,n);
[Y,X] = meshgrid(x,x);


% compute radius distribution
k = 200;        % sampling rate of the distrib
r_list = linspace(rmin,rmax,k);
r_dist = 1./r_list.^sigma_n;
if sigma_n>0
    r_dist = r_dist - 1/rmax^sigma_n;
end

%r_dist = rescale( cumsum(r_dist) ); % in 0-1 ## rescale not available in octave
xx = cumsum(r_dist);
mm = min(xx(:));
MM = max(xx(:));

if MM-mm<eps
    r_dist = xx;
else
    r_dist = (1-0) * (xx-mm)/(MM-mm) + 0;
end


m = n^2;

for i=1:nbr_iter
    

	% compute scaling using inverse mapping
    r = rand(1);  
	[tmp,I] = min( abs(r-r_dist) );
    r = r_list(I);
    
    x = rand(1);    % position 
    y = rand(1);
    a = rand(1);    % albedo
    
    if strcmp(shape, 'disk')
        I = find(isinf(M) & (X-x).^2 + (Y-y).^2<r^2 );
    else
        I = find(isinf(M) & abs(X-x)<r & abs(Y-y)<r );
    end
    
    m = m - length(I);
    M(I) = a;
    
    if m==0
        % the image is covered
        break;
    end
end

% remove remaining background
I = find(isinf(M));
M(I) = 0;