function [S,D]=genseed(self, lb)
%this code will be run for each soma. inputSeg is the segmented image
%where all soma regions set equal to zero but the selected one.
%inputSoma(which is not required here though) is the soma region of the
%selected one.

cutOff=2*(sqrt(2)-1/2);
sz=size(self.inputSeg);
inputb=ones(sz);
inputb(find(self.inputSeg))=0;

distMap=bwdist(inputb);
distMap(distMap<1)=1;

F= (-1/8) * ones(3); F(2,2)=2;%filter to enhance the centerline points.

xCenter=convn(distMap,F,'same');
xCenterN=zeros(size(xCenter,1)+6,size(xCenter,2)+6);
xCenterN(4:(3+size(xCenter,1)),4:(3+size(xCenter,2)))=xCenter;
distMapN=zeros(size(distMap,1)+6,size(distMap,2)+6);
distMapN(4:(3+size(distMap,1)),4:(3+size(distMap,2)))=distMap; %zero padding

xCenter=xCenterN;
distMap=distMapN;
xCenter=xCenter./(max(xCenter(:)));

xCenter_1=zeros(size(xCenter));
xCenter_1((xCenter>lb))=xCenter((xCenter>lb));
xCenter_nonzeros=find(xCenter_1);
xCenter=xCenter_1;

nbhBox=[-1 -1; 0 0;1 1; -1 0; 0 -1;1 0; 0 1;1 -1; -1 1];
V=zeros(size(xCenter_nonzeros));


for i=1:length(xCenter_nonzeros)
    [a,b]=ind2sub(size(xCenter),xCenter_nonzeros(i));
    neigh=[a.*ones(9,1) b.*ones(9,1)]+nbhBox;
    neigh=sub2ind(size(xCenter),neigh(:,1), neigh(:,2));
    x=max(distMap(neigh));
    y=distMap(a,b);
    if ((x-y)< cutOff)
        V(i)=1;
    end
end
xCenter_nonzeros=xCenter_nonzeros(V~=0);
V=ones(size(xCenter_nonzeros));
for i=1:length(xCenter_nonzeros)
    [a,b]=ind2sub(size(xCenter),xCenter_nonzeros(i));
    neigh=[a.*ones(9,1) b.*ones(9,1)]+nbhBox;
    neigh=sub2ind(size(xCenter),neigh(:,1), neigh(:,2));
    x=max(distMap(neigh));
    y=distMap(a,b);
    if (x<y)
        V(i)=0;
    end
end

xCenter_nonzeros=xCenter_nonzeros(V~=0);
xCenterDistMap=zeros(size(distMap));
xCenterDistMap(xCenter_nonzeros)=distMap(xCenter_nonzeros);

%l=numel(find(xCenterDistMap));
S=[];
while (max(xCenterDistMap(:))>0)
    [~,index]=max((xCenterDistMap(:)));
    S=[S index];
    [a,b]=ind2sub(size(xCenter),index);
    neigh=[a.*ones(9,1) b.*ones(9,1)]+nbhBox;
    neigh=sub2ind(size(xCenter),neigh(:,1), neigh(:,2));
    xCenterDistMap(neigh)=0;
end
g=zeros(size(xCenterDistMap)); g(S)=1; g=g(4:(3+size(self.inputSeg,1)),4:(3+size(self.inputSeg,2))); S=find(g);
D=distMap(4:(3+size(self.inputSeg,1)),4:(3+size(self.inputSeg,2)));
base=self.inputSeg;
base(S)=5;
inputS=self.inputSoma;
base=base.*inputS; somaSeeds=find(base==5);
%SS=secondRoundSeeding(self, D, S); S=[S; SS];
S2=eliminate_extra_seeding(S,D,sz);
S=unique(S2);
S=[S; somaSeeds];
base=self.inputSeg;
base(S)=5; figure; imshow(base,[],'InitialMagnification',9000)
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017


