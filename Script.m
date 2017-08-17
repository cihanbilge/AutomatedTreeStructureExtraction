% main script for neurite tracing
close all
clear all

%load segmented binary image and segmented soma mask
load('inputSeg');
load('inputSoma');
%cell_rect is pre-generated rectangles for seed search. For parameters are
%not needed to be changed, same rectangles can be used for each of the images in dataset
%if it is not required to create rectangles again set option.rect=0 and
%option.cell=cell_rect;
option.rect=1;
%option.rect=0; option.cell=cell_rect;
[neuriteGraph,cell_rect]=runCenterLineParallel(inputSeg,inputSoma,option);

