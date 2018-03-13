% main script for neurite tracing
close all
clear all

%load segmented binary image and segmented soma mask
load('inputSeg');
load('inputSoma');
%
%For the first run you need to create "seed search rectangles". In that case you need to set: 
%option.rect=1, 
%
%However, if you already created the rectangles and saved them with name "cell_rect", 
%then you do not need to create rectangles again, that will help to reduce computational cost
% In that case set: option.rect=0 and option.cell=cell_rect;
%
option.rect=1;
%to allow manual intervention: option.manual=1; 
%to make it fully automated: option.manual=0;
option.manual=1;
tic;
[neuriteGraph,cell_rect]=runCenterLineParallel(inputSeg,inputSoma,option);
a=toc;


