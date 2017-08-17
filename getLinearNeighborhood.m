function ngh=getLinearNeighborhood(point, r)
%get neighborhood around point with given radius
%r is odd
ngh=[];
x=[-(r-1)/2: (r-1)/2];
for i=1:length(x)
    for j=1:length(x)
        ngh=[ngh; point(1)+x(i) point(2)+x(j)];
    end
end

end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017

