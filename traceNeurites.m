function [neuGraph_path]=traceNeurites(self,D,S,se,cell_inc,lenghtToSearch,NumofBands,NumofIncrement)
%this function is run for each soma.
%INPUT:
%self: struct contains segmented image and segmented soma masks of image.
%D: distance map,
%S: array of generated seeds,
%se: disk struct element for image dilation.
%OUTPUT:
%neuGraph_path: cell contains all neurite traces of soma,

xSoma=self.xSoma;
xSeg=self.xSeg;
inputSeg=self.inputSeg;
inputSoma=self.inputSoma;
minNeuLen=3; %minimum length for a neurite
dilatedSoma=imdilate(xSoma,se);
xNeurites = double(xSeg).*(1-dilatedSoma); xNeurites(xNeurites<=0)=0;
xSegAndDilatedSoma = xSeg;
xSegAndDilatedSoma(find(dilatedSoma))=1;
selectedcomponents = findNeuriteComponents(S,xNeurites, xSeg, xSoma, dilatedSoma, D);
%somaSeeds=find(xSoma);
somaSeeds=find(inputSoma);
neuriteSeeds = setdiff(S, somaSeeds);
l=length(selectedcomponents);
neuGraph_path=cell(1); %size is determined later

for i=1:l
    SC=selectedcomponents{i};
    if (isempty(SC)==0)
        neuSeed = intersect(find(SC.neu), neuriteSeeds);
        neu=SC.neu;
        pInNeurite=SC.pInNeurite;
        pInSoma=SC.pInSoma;
        %get coordinates for neuriteSeeds:
        [k1,k2]=ind2sub(size(SC.neu), neuSeed);
        neuSeed_sub=[k1 k2];
        neuStartSeed = findClosestPoint(pInSoma, neuSeed_sub);
        xNeuD=D;
        weight = 1.0./max(xNeuD,1);
        [path] = findNeuritePath(neuriteSeeds,xNeuD,pInSoma, pInNeurite,neuStartSeed, neuSeed, neu, weight,inputSeg,cell_inc,lenghtToSearch,NumofBands,NumofIncrement);
        if (size(path,1) > minNeuLen)
            neuGraph_path{i}=path;
        end
    end
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017
