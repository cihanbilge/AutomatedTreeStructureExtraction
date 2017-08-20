function [point,points]=findfurthestPoint(X,Y)
% finds the furthest point in array Y to X
if (isempty(Y)==0)
    dist=[];
    for i=1:size(Y,1)
    dist=[dist (X(1)-Y(i,1))^2+(X(2)-Y(i,2))^2];
    end
    [~,I]=sort(dist,'descend'); 
    if (numel(I)==0)
        point=[]; points=[];
    else
    point= Y(I(1),:);
    points=Y(I(1:min(3,size(Y,1))),:);
    end
else 
    point=[];
    points=[];
end


% Created by Cihan Kayasandik
%August 2017
