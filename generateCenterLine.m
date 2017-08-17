function [path_neu,D]=generateCenterLine(inputSeg, inputSoma, lb,cell_inc,lenghtToSearch,NumofBands,NumofIncrement)
% this code generates the centerline tracing for each neurite of each soma
% INPUT:
% inputSeg: segmented image,
% inputSoma: segmented soma mask,
% lb: density for seed generation, 
% cell_inc: cell contains pre-generated rectangles for seed search.
% OUTPUT:
% path_neu: cell contains tree structure of input,
% D: Euclidean distance map of input.

self.zSmear=1;
self.cutOff=sqrt(2)-1/2; 
self.inputSeg=inputSeg;
self.inputSoma=inputSoma;
se=strel('disk',2);
Somas=connComp(inputSoma);
comp_Num=Somas.compNum;
path_neu=cell(comp_Num); 
[S,D]=genseed(self,lb); %generate seeds

for i=1:comp_Num
tic;
    diffSomas=setdiff(1:comp_Num,i);
    base=zeros(size(inputSeg));
    for j=1:size(diffSomas,2)
        base(Somas.compIdx{diffSomas(j),1})=1;
    end
    xSoma=zeros(size(inputSeg)); xSoma(Somas.compIdx{i,1})=1; xSoma=imdilate(xSoma,se);
    xSeg=inputSeg; xSeg(base==1)=0;
    self.xSeg=xSeg; self.xSoma=xSoma;
    [neuGraph_path] = traceNeurites(self,D,S,se,cell_inc,lenghtToSearch,NumofBands,NumofIncrement); 
toc;
path_neu{i}=neuGraph_path; 
end
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017
