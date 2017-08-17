function [path]=findNeuritePath(neuriteSeeds,xNeuD,pInSoma, pInNeurite, neuStartSeed, neuSeed, neu, weight,inputSeg,cell_inc,lenghtToSearch,NumofBands,NumofIncrement)
%starting from the starting point and the initial direction of neurite, it
%traces through neurite.

sz=size(weight);
maxNeuLen=floor(sqrt(sz(1)^2+sz(2)^2)/2);
path = pInSoma;
neuSeeds=inputSeg;
nbhBox = getLinearNeighborhood_p(size(weight), 1); % 1);
nbhBox=nbhBox(nbhBox~=0);
nS = neuStartSeed; nS_ind=sub2ind(sz,nS(1),nS(2));
idx = find(neuriteSeeds == sub2ind(sz,nS(1),nS(2)));
r = ceil(max(xNeuD(:)));
[dirEstimate, ~] = getPCA(neuriteSeeds,sz, r); 
prinCompAtSeed = dirEstimate(idx(1),:);

subpath = joinSeedToPath(nS,nS_ind, path, neuSeeds, nbhBox,prinCompAtSeed, weight);
path = [sub2ind(size(weight),path(1), path(2)); subpath(2:end)];

FLAG = 1;
      
uS=setdiff(neuSeed,path);
cS = neuStartSeed(end,:);
pS = pInSoma(1,:);
ignoreSeedSet = [];
uS=setdiff(uS,sub2ind(sz, pInNeurite(1), pInNeurite(2)));
while (FLAG==1)
    uS = setdiff(uS, path); uS=setdiff(uS,ignoreSeedSet); 
    if (isempty(uS)==1)
        break
    else
        [nS,nS_ind] = getNextSeed(neu,pS, pInNeurite, cS, uS, ignoreSeedSet,sz,cell_inc,lenghtToSearch,NumofBands,NumofIncrement);
        if (isempty(nS)==1 || (sqrt((cS(1)-nS(1))^2+(cS(2)-nS(2))^2)) > 70)
            FLAG = 0;
           break
        end
    end
    
    idx = find(neuriteSeeds == nS_ind); idx=idx(1);
    prinCompAtSeed = dirEstimate(idx,:);
    path_1=path(end);
    subpath = joinSeedToPath(nS,nS_ind, path_1, neuSeeds, nbhBox,prinCompAtSeed, weight);
    if (isempty(subpath)==1)
        FLAG = 0;
        break
    end
    if (path(end)~= subpath(1))
        continue
    end
    path = [path; subpath(2:end)]; n=neu; n(path)=6; n(neuriteSeeds)=3;  imshow(n,[])
    if (size(path,1) > maxNeuLen)
        FLAG = 0;
        break
    end
    pS = cS;
    [cS1,cS2] = ind2sub(sz,path(end)); cS=[cS1 cS2];
    pInNeurite = cS;
end
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017
