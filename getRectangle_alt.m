function [rectangle]=getRectangle_alt(pnt11,dd,dr,length,thk,sz)
%creates rectangle with given length,slope,width and location. pnt11 is the starting
%point of rectangle it is on boundary.

dir1=dd(1)/dr; dir2=dd(2)/dr;
h1=ceil(max(abs((thk/2)*dir1), abs((thk/2)*dir1))+10);
h2=ceil(max(abs(length*dir1), abs(length*dir2)))+10;
h=max(h1,h2);
new_sz=sz+[ceil(2*h) ceil(2*h)];
pnt1=pnt11+[h h];

pnt=pnt1;
%firstly find the bottom corners
p1=ceil(pnt+(thk/2)*[dir2 -dir1]); 
p2=ceil(pnt-(thk/2)*[dir2 -dir1]); 

%find mid top point
pt=ceil(pnt+(length)*[dir1 dir2]); 
%find top corners
p1t=ceil(pt+(thk/2)*[dir2 -dir1]); 
p2t=ceil(pt-(thk/2)*[dir2 -dir1]); 

rectangle=zeros(new_sz);

u1=sub2ind(new_sz,pnt(1),pnt(2)); rectangle(u1)=1; 
u2=sub2ind(new_sz,p1(1),p1(2)); rectangle(u2)=1; 
u3=sub2ind(new_sz,p2(1),p2(2)); rectangle(u3)=1; 

u4=sub2ind(new_sz,pt(1),pt(2)); rectangle(u4)=1; 

u5=sub2ind(new_sz,p1t(1),p1t(2)); rectangle(u5)=1; 
u6=sub2ind(new_sz,p2t(1),p2t(2)); rectangle(u6)=1; 

rectangle=bwconvhull(rectangle); 
rectangle=rectangle(h+1:sz(1)+h,h+1:sz(2)+h);
end

% Created by Cihan Kayasandik
%August 2017





