function S2=eliminate_extra_seeding(S,D,sz)
%eliminates extra seeds in 8-neighborhood of each seed.
S2=[];
im=zeros(sz); 
im(S)=1; im=im.*D; 
nbhBox=getLinearNeighborhood_p(sz,2); 
for i=1:length(S)
    seed=S(i);
    [nbhd, cntr] = meshgrid(nbhBox, seed);
    neig = unique(nbhd+cntr); neig=neig(neig>0); neig=neig(neig<sz(1)*sz(2)); neig=intersect(neig,S);
    m=max(D(neig)); 
    if (D(seed)>=m )
        S2=[S2; seed];
    end
end
end


% Created by Cihan Kayasandik 
%August 2017