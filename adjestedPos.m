function [position,arcS, arcC,d]=adjestedPos(dd,cell_inc,nBands,cent,neu)
% It takes the direction of neurite and segmented image, and 
% adjusts the direction of neurite by finding the principal component of 
% neurite at the initial point.  

% INPUT: 
% dd: difference between the initial seed point and the previous seed
% point, it is used to find the direction of neurite. 
% cell_inc: cell of rectangles in each directions and in different sizes,
% nBands: number of filter orientations,
% cent: initial seed point,
% neu: segmented image.

%OUTPUT:
% position: adjusted direction of neurite,

q=getquadrant(dd);
num=atand(abs(dd(2)/dd(1)));
if (mod(q,2)==0)
    num=abs(90-num);
end
position=90*(q-1)+num;
d=dd(2)/dd(1); d=atan(d);
dr = sqrt(dot(dd', dd));
arcC = acos(dd(1)/dr);
arcS = asin(dd(2)/dr) ;

%adjust position
cd=cell_inc{1}; c=cd{1};
for i=1:3
    xTemp1 = double(c{max(mod(ceil(position+i*180/nBands),360),1)});
    xTemp1=imtranslate(xTemp1,cent,'FillValues',0);
    cem(1,i)=sum(sum(xTemp1.*neu));
    %figure; imshow(neu,[]);
    xTemp2 = double(c{max(mod(ceil(position-i*180/nBands),360),1)});
    xTemp2=imtranslate(xTemp2,cent,'FillValues',0);
    cem(2,i)=sum(sum(xTemp2.*neu));
end

[~,b]=max(cem(:));
b=ceil(b/2); r=rem(b,2);
if (r==0)
    position=position-b*180/nBands;
elseif (r==1)
    position=position+b*180/nBands;
end

end