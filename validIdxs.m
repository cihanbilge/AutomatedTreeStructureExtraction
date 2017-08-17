function I=validIdxs(nbh, sz)
I=[];
for i=1:size(nbh,2)
    if i < sz(1)*sz(2)
        I=[I i];
    end
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017