function [SS]=secondRoundSeeding(self, xDistTrans, S)
% this code is run after the seed generation. It detects large areas 
%where no seed is generated for. And generate seeds for those areas.

%prepare soma mask for distance function.
inputSoma=self.inputSoma;
inS=inputSoma; inS(inS==0)=2; inS(inS==1)=0; inS(inS==2)=1;
xDistTrans=xDistTrans.*inS;
DS = ceil(2.0*xDistTrans(S));
sz = size(xDistTrans);
SS = [];
%create a box around each seed point with side equals to distance between
%seed point and boundary of neurite. Then eliminate this box for the second
%round of seeding process. There is no need to generate seed for this area.

for seedIdx=1:length(S)
    seed=S(seedIdx);
    [x,y] = ind2sub(sz,seed);
    II = -DS(seedIdx):DS(seedIdx)+ 1;
    xI = x + II;    
    yI = y + II;
    xI=reshape(xI,[numel(xI), 1]);
    yI=reshape(yI,[numel(yI),1]);
    for o=1:size(xI,1)
        if (xI(o)>0 && xI(o)<=sz(1))
            for ot=1:size(yI,1)
                if  (yI(ot)>0 && yI(ot)<=sz(2))
                    xDistTrans(xI(o),yI(ot))=0;
                end
            end
        end
    end
end
% after these boxes are generated for each seed point and eliminated from
% the distance map, check the remaining areas if there is any point who is
% at least 3 pixels away from the boundary. IF there is generate seeds for
% such areas.
while (isempty(xDistTrans> 3)==0) 
    m = max(xDistTrans);
    idx = find(xDistTrans == m);
    m = ceil(2*m);
    [x,y] = ind2sub(sz,idx);
    II = [-m: m+1];
    xI = x + II;
    yI = y + II;
    xI=reshape(xI,[numel(xI), 1]);
    yI=reshape(yI,[numel(yI),1]);
    for o=1:size(xI,1)
        if (xI(o)>0 && xI(o)<=sz(1))
            for ot=1:size(yI,1)
                if  (yI(ot)>0 && yI(ot)<=sz(2))
                    xDistTrans(xI(o),yI(ot))=0;
                end
            end
        end
    end
    SS=[SS; idx];
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017