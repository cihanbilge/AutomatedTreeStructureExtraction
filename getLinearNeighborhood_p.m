 function [nbhBox]=getLinearNeighborhood_p(sz, r)
 % build the nbh box around valid pixels.
  %based on indexes
 box=[1 sz(1)];

 [nx, ny] = meshgrid(linspace((-r*box(1)), r*box(1),(2*r+1)), linspace((-r*box(2)), r*box(2),(2*r+1)));        
 nbhBox =nx+ny;
 Nb=[];
 for i=1:size(nbhBox,1)
     Nb=[Nb nbhBox(i,:)];
 end
 nbhBox=Nb;
 end
 
 

% Created by Cihan Kayasandik and Pooran Negi
%August 2017
