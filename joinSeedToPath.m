function [subpath]= joinSeedToPath( nS,nS_ind, path_1, neuSeeds, nbhBox, prinCompAtSeed, weight)
% This function connect the next seed nS to the generated path.
% INPUT:
%  - nS: next seed to connect to current path.
%  - nS_ind: index of next seed to connect to current path.

%  - path_1: current path
%  - prinCompAtSeed: principle component direction at nex seed
%  - weight: weight matrix for shortest path alogorithm used
% OUTPUT:
%  - subpath: subpath from path to nS

sz=size(weight);
x = -1:1;
[X,Y] = meshgrid(x,x);
D = sqrt(X.^2 + Y.^2); X=X'; Y=Y';
X = X(D~=0);
Y = Y(D~=0);
D = D(D~=0);
X = X./D;
Y = Y./D;
A = [X Y];

%it is assumed that path is in coordinates, so convert to indices\
ind=[];
if (size(path_1,2)==2)
    
    ind=[ind; sub2ind(sz,path_1(:,1), path_1(:,2))];
    
    path_1=ind;
end
direction = prinCompAtSeed*A';%not clear to me
[~,dirSeed] = max(direction);
region = sub2ind(sz,nS(1), nS(2));%next seed
prevnb = sub2ind(sz,nS(1), nS(2));

FLAG = 1;
while (FLAG==1)
    [nbhd, cntr] = meshgrid(nbhBox, prevnb);
    neig = unique(nbhd+cntr);%deleted neigh of prevenb(nS)
    neig = intersect(neig, find(neuSeeds));
    prevnb = setdiff(neig, region);% prevenb=deleted neigh
    region = [region; neig];%neigh not deleted
    [TF, ~] = ismember(neig, path_1);
    if (any(TF) || numel(neig)==0)
        FLAG = 0;
    end
end
% Dijkstra
region = unique(region);
[nbhd, cntr] = meshgrid(nbhBox, region);
adjm = nbhd + cntr;
% @TODO this returns -1 in locs
[edgs, locs] = ismember(adjm, region);
%[~, reg] = ismember(region, find(neuSeeds));
wgar = weight(region); %was reg originally
vstd = zeros(size(region)); %# visited vertices.
valu1 =zeros(size(region)); %#Value to reach resp vertex
%# @TODO should we use inf or max in valu1 and valu2
valu1= realmax*ones(size(valu1));
valu2 = zeros(size(region));
valu2 = realmax*ones(size(valu2)); %# Second Value
prnt = zeros(size(region)); %# Parent
drtn = zeros(size(region)); %# Direction
nxeg = zeros(size(region)); %# Next edges to visit
nxrd = zeros(size(region)); %# Next round
path_1 = intersect(path_1, region);
[~, path_1] = ismember(path_1, region);
repl=region(path_1);
nS = find(region == nS_ind); nS=nS(1);
nxeg(nS) = 1;
vstd = zeros(size(region)); %# visited vertices.

valu1(nS) = 0;
valu2(nS) = 0;
drtn(nS) = dirSeed;

FLAG = 1;
A=A';
while (FLAG==1)
    while (any(nxeg) && all(vstd(path_1))==0)
        idx = find(nxeg); idx=idx(1); %if there are zero terms take first nonzero one and float %# index to process
        nxeg(idx) = 0; %# index has been visited
        npsqueeze=(edgs(idx,:))';
        neig = locs(idx, npsqueeze);
        neig = setdiff(neig, find(vstd));
        [~, I] = ismember(neig, locs(idx, :));
        nxrd(neig) = 1;
        
        if (size(I,2) > 0)
            neigIdx = region(neig);
            [neigX, neigY] = ind2sub(size(weight),neigIdx);
            neigCoord = [neigX neigY];
            [x, y] = ind2sub(size(weight),repl);
            pathDir = [x y];
            if (size(pathDir,1) > 1)
                pathDir = mean(pathDir,1);
            end
            
            pathDir = repmat(pathDir, size(neigCoord,1),1);
            pathDir = pathDir - neigCoord;
            try
                pathDir = pathDir./(repmat(sqrt(diag((pathDir*pathDir')))',size(pathDir,2),1))';
            catch
                disp('invalid')
            end
            pathDir(isnan(pathDir)) = 0;
            frstDir = A(:, I);
            
            prvw1 = valu1(neig);
            %prvw2 = valu2(neig);
            curw1 = wgar(neig) + valu1(idx);
            curw2 = 1 - sum(pathDir*frstDir, 1);
            try
                adjv = (curw1 < prvw1);
            catch
                disp('Warning raised')
            end
            adjv = find(adjv);
            adin = neig(adjv);
            valu1(adin) = curw1(adjv);
            valu2(adin) = curw2(adjv);
            drtn(adin) = adjv;
            prnt(adin) = idx;
        end
        vstd(idx) = 1;
    end
    neig = setdiff(find(nxrd), find(vstd));
    nxeg(neig) = 1;
    
    if (size(nxeg,1)==0 || all(vstd(path_1)))
        FLAG = 0;
    end
end

if (size(valu1(path_1)) == 0)
    subpath=[];
end

[~,i] = min(valu1(path_1));
idx = path_1(i);
subpath = (idx);

if (isempty(idx)==1)
    idx=0;
end

while ((idx ~= nS) && idx~=0)
    idx = prnt(idx);
    subpath=[subpath idx];
end
if (length(subpath)<80)
    subpath = region(subpath);
else
    subpath=[];
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017
