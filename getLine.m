function [xTemp1]=getLine(cSXY, arcC, arcS, sz, length, thk, rotAngle)
%creates a line with given thickness, length, direction and starting point.
xTemp = zeros(sz);
tSX1 = floor(cSXY(2) + length*cos( arcC));
tSY1 = floor(cSXY(1) + length*sin(arcS));
if (tSX1<=0)
    tSX1=1;
end
if (tSY1<=0)
    tSY1=1;
end
x=[tSY1   cSXY(2)];
y=[tSX1  cSXY(1)];
for i=1:2
    if (x(i)>sz(1))
        x(i)=sz(1);
end
    if  (y(i)>sz(2))
        y(i)=sz(2);
end
    if (y(i)<1)
        y(i)=1;
end
    if  (x(i)<1)
        x(i)=1;
    end


    xTemp(y(i),x(i))=1;
end
xTemp=bwconvhull(xTemp); xTemp=double(xTemp);
sd=strel('square', ceil(thk));
xTemp1=imdilate(xTemp,sd);
if (rotAngle~=0)
    center=[cSXY(1) cSXY(2)];
    xTemp1=rotateAroundPoint(xTemp1, rotAngle, center,sz);
end
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017

