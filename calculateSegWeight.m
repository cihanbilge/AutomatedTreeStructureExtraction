function [w]=calculateSegWeight(x, y,sz)
%this function calculates the weight based common area
if (size(x,2)==1)
    xt=zeros(sz);
    xt(x)=1;
    x=xt;
end

z = x&y;
w = 1.0*numel(find(z)) /(numel(find(x))+1);
w=w^2; 
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017
