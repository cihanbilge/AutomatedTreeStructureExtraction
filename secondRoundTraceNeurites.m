function [newpath]=secondRoundTraceNeurites(im,inputSeg,path,S_c,neuriteSeeds,xNeuD,neuStartSeed, neuSeed, neu, weight,cell_inc,lenghtToSearch,NumofBands,NumofIncrement)
%   This function is called only if manual intervention is included in
%   options (for that set option.manual=1). If the trace is not correct,
%   this function runs the whole tracing process through involving the selected
%   point in trace.

imshow(im,[],'InitialMagnification',10000);
[X, Y]= getpts
X=ceil(X); Y=ceil(Y);% choose the astrocytes to segment
[point,~]=findClosestPoint([Y X],S_c); point_i=sub2ind(size(inputSeg),point(1),point(2));
if (sqrt((Y-point(1))^2+(X-point(2))^2)>30)
    disp('not possible')
    newpath=path;
    return
end

pathm=setdiff(path,point_i);
path_c=[];
for k=1:length(pathm)
    [a,b]=ind2sub(size(inputSeg),pathm(k));
    path_c=[path_c; a b];
end
[lastSeed,~]=findClosestPoint(point,path_c);
ord=find(path==sub2ind(size(inputSeg),lastSeed(1), lastSeed(2)));
path=path(1:ord);
newpath=secondRoundtracing(path, point, point_i,neuriteSeeds,xNeuD,neuStartSeed, neuSeed, neu, weight,inputSeg,cell_inc,lenghtToSearch,NumofBands,NumofIncrement);



end

