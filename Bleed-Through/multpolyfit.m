function [c1,c2] = multpolyfit(x,y,n)
% by Matt Tearle [MATLAB Staff]
% 3D fitting of [X,Y] to [n]-degree

m = size(x,3);
c1 = zeros(n+1,m);
tic
for k=1:m
    c1(:,k) = polyfit(x(:,:,k),y(:,:,k),n)';
end
toc
c2 = zeros(n+1,m);
tic
for k = 1:m
    M = repmat(x(:,k),1,n+1);
    M = bsxfun(@power,M,0:n);
    c2(:,k) = M\y(:,k);
end
toc