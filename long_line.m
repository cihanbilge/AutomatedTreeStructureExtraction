function Img= long_line(Img,X,Y,sym_len,thk)
%creates a line in the direction of line from X to Y. 
%Img: line is created on image Img,
%X and Y determines the direction of line,
%sym_len: length of line,
%thk: thickness of line.

thk=ceil(thk/2);
sz=size(Img);
sy_len=sym_len;
%mid point:
m_px=(X(1)+Y(1))/2;
m_py=(X(2)+Y(2))/2; 
dir=[Y(1)-X(1),Y(2)-X(2)];
dirx=(Y(2)-X(2));
diry=(Y(1)-X(1)); 
t=1;

    
if (abs(dir)==Inf)
    Yp = [m_px m_py+ dir*sym_len]; Yp=[max(Yp(1),1) max(Yp(2),1)];  %Yp=[min(Yp(1),sz(1)) min(Yp(2),sz(1))];
    Xp = [m_px m_py- dir*sym_len]; Xp=[max(Xp(1),1) max(Xp(2),1)];  %Xp=[min(Xp(1),sz(1)) min(Xp(2),sz(1))];
else if (abs(dir)==0)
        Yp = [m_px+ dir*sym_len m_py]; Yp=[max(Yp(1),1) max(Yp(2),1)];  %Yp=[min(Yp(1),sz(1)) min(Yp(2),sz(1))]; 
        Xp = [m_px- dir*sym_len m_py]; Xp=[max(Xp(1),1) max(Xp(2),1)];  %Xp=[min(Xp(1),sz(1)) min(Xp(2),sz(1))];
    else
        Yp=[2*Y(1)-m_px 2*Y(2)-m_py]; Yp=[max(Yp(1),1) max(Yp(2),1)];  %Yp=[min(Yp(1),sz(1)) min(Yp(2),sz(1))];
        Xp=[2*X(1)-m_px 2*X(2)-m_py]; Xp=[max(Xp(1),1) max(Xp(2),1)];  %Xp=[min(Xp(1),sz(1)) min(Xp(2),sz(1))];
    end
end
        s=1;
        x=[Yp(2)-thk Xp(2)-thk  Xp(2)+thk Yp(2)+thk Yp(2)-thk];
        y=[Yp(1)-thk Xp(1)-thk Xp(1)+thk Yp(1)+thk Yp(1)-thk];
        while (any(x>sz(1)) || any(x<1) || any(y>sz(2)) || any(y<1))
        Yp=[2*Y(1)-(1+s/10)*m_px 2*Y(2)-(1+s/10)*m_py]; Yp=[max(Yp(1),1) max(Yp(2),1)];  %Yp=[min(Yp(1),sz(1)) min(Yp(2),sz(1))];
        Xp=[2*X(1)-(1+s/10)*m_px 2*X(2)-(1+s/10)*m_py]; Xp=[max(Xp(1),1) max(Xp(2),1)]; 
        s=s+1;
                x=[Yp(2)-thk Xp(2)-thk  Xp(2)+thk Yp(2)+thk Yp(2)-thk];
        y=[Yp(1)-thk Xp(1)-thk Xp(1)+thk Yp(1)+thk Yp(1)-thk];
        end
        K=zeros(size(Img));
        for i=1:size(x,2)
            K(ceil(y(i)),ceil(x(i)))=1;
        end
        K=bwconvhull(K);
        Img(find(K))=1;
end