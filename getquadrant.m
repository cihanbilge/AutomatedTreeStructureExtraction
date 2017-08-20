function q= getquadrant(dd)
%gives the quadrant of point.
%dd is given 
 x=dd(1); y=dd(2);
 if (x>0)
     if (y>0)
         q=2;
         else 
             q=3;
         end
     
 end
 if (x<0)
     if (y>0)
         q=1;
         else 
             q=4;
         end
     
 end
if (x==0)
if (y>0)
q=1;
elseif (y<0)
q=3;
end
end

if (y==0)
if (x>0)
q=3;
elseif (x<0)
q=5;
end
end
  
end
% Created by Cihan Kayasandik 
%August 2017