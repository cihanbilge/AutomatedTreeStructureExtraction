function [V, invalidIdx]=getPCA(S,sz,r)
%INPUT: S : Set of seeds
 %   sz : The shape of orignal data
 %   OUTPUT: V : Matrix of principle components of the elements in the 
 %   seeds   
 %         :invalidIdx  indexes in S where PCA could not be calculated

 invalidIdx = [];   
 nbhBox = getLinearNeighborhood_p(sz, r);
 V = zeros(size(S,1),2);%only for 2d
 for i=1:size(S,1)
     seeds=S(i)+nbhBox;
  I = intersect(seeds, S);
  if (size(I,1)<=1)
    tempNbhBox = getLinearNeighborhood_p(sz,2*r);
    I = intersect(S(i) + tempNbhBox, S);
  end
  if (size(I,1)<=1)
    invalidIdx = [invalidIdx; i];    
    continue
  end
    [I1,I2]=ind2sub(sz,I); I=[I1 I2];
  [P,~,~] = princomp(I');
  V(i, :) = P;
 end

