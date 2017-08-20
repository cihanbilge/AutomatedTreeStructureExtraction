function [neuriteGraph,cell_inc]=runCenterLineParallel(inputSeg,inputSoma,option)
%main function to run. 
%Input: 
%inputSeg: segmented image,
%inputSoma: segmented soma regions.
%Output:
%neuriteGraph: cell contains all neurite traces of all somas,
%densityMap: cell contain densities extracted along the traced neurites of each somas.
%cd('/Users/cihanbilgekayasandik/Desktop/tracing_inpreparations_2');

%pre-generation of rectangles for seed search
lenghtToSearch=40; 
thickness=9; 
NumofIncrement=18; 
NumofBands=20; %number of orientations to search
if (option.rect==1)
    cell_inc=createRectangles(lenghtToSearch,thickness, NumofIncrement, NumofBands, size(inputSeg));
else
    cell_inc=option.cell;
end
%tic;
CCC=connComp(inputSeg);
THR=300;
InSidx = cat(1, CCC.compIdx{CCC.compCard > THR});
InS = zeros(size(inputSeg));
InS(InSidx) = 1;
inputSeg=InS;
lb=0.08; 
[neuriteGraph,D]=generateCenterLine(double(inputSeg), inputSoma, lb,cell_inc,lenghtToSearch,NumofBands,NumofIncrement,option);
%toc;

%density estimation
%patchsize=3;

%densityMap=densityEstimate(image_red, neuriteGraph,D,patchsize);
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017

