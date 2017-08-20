function [neuGraph_path]=traceNeurites(self,D,S,S_c,se,cell_inc,lenghtToSearch,NumofBands,NumofIncrement,option)
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
        if (option.manual==1)
            if (isempty(path)==0)
                t=0;
                while (t==0)
                im=inputSeg; im(path)=2; imshow(im,[],'InitialMagnification',9000);
                prompt = 'Is this the correct path? If so press 1. If not press 0 and choose a point by double clicking to correct the path. If you want to eliminate this trace press 3.';
                x = input(prompt);
                if (x==1)
                    neuGraph_path{i}=path; t=1;
                elseif (x==3)
                    neuGraph_path{i}=[]; t=1;
                end
                while (x==0)
                [newpath]=secondRoundTraceNeurites(im,inputSeg,path,S_c,neuriteSeeds,xNeuD,neuStartSeed, neuSeed, neu, weight,cell_inc,lenghtToSearch,NumofBands,NumofIncrement);
                neuGraph_path{i}=newpath; path=newpath;
                x=2;
                 t=0;   
                end
                end
            end
        end
    end
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017
