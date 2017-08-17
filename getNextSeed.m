function [nS, nS_ind]=getNextSeed(neu,pS, pInNeurite, cS, uS,ignoreSeedSet, sz, cell_inc,lengthToSearch,nBands,NumofIncrement)
%all inputs are in coordinates not indices except uS
distRangePixel=60;
angBound=3*pi/5;
pSXY1=pS(1); pSXY2=pS(2);
cSXY1=pInNeurite(1); cSXY2=pInNeurite(2);
cs=sub2ind(sz,pInNeurite(1),pInNeurite(2));

dd = [cSXY1 cSXY2] - [pSXY1 pSXY2];
center=[cSXY2 cSXY1]-sz/2;
% adjust position by finding the principal component of neurite at the
% initial position
[position,arcS,arcC,d]=adjestedPos(dd,cell_inc,nBands,center,neu);

%
cSXY=cS;
uS=setdiff(uS,sub2ind(sz,cS(1),cS(2)));
nS = [];
ty=1;
s=1;
while  s<=NumofIncrement-1
    cd=cell_inc{s};
    if (ty==1 && isnan(sin(arcS))==0 && isnan(cos(arcC))==0)
        idx = 0;
        dist = distRangePixel+1;
        while (idx <=nBands/2 -5  && (dist > distRangePixel || isempty(nS) == 1) && ty==1)
            c=cd{idx+1};
            if (any(isnan(cSXY))==1)
                continue
            end
            xTemp1 = double(c{max(mod(ceil(position+idx*180/nBands),360),1)});
            xTemp1=imtranslate(xTemp1,center,'FillValues',0);
            xTemp2 = double(c{max(mod(ceil(position-idx*pi/nBands),360),1)});
            xTemp2=imtranslate(xTemp2,center,'FillValues',0);
            % for visualization
            %base=zeros(sz); base(find(xTemp1))=1; base(find(xTemp2))=1; base(uS)=2;
            %figure; imshow(base,[]); pause(1);
            %%
            nSSet = intersect(uS, find(xTemp1));
            nSSet = setdiff(nSSet, ignoreSeedSet);
            [nSSet1, nSSet2]=ind2sub(sz,nSSet);
            nSSet=[nSSet1, nSSet2];
            %nS1 = findClosestPoint(cS, nSSet); nS1_c=nS1;
            nS1 = findfurthestPoint(cS, nSSet); nS1_c=nS1;
            if (numel(nS1)~=0)
                nS1=sub2ind(sz, nS1(1), nS1(2));
            end
            nSSet = intersect(uS, find(xTemp2));
            nSSet = setdiff(nSSet, ignoreSeedSet);
            [nSSet1, nSSet2]=ind2sub(sz,nSSet); nSSet=[nSSet1, nSSet2];
            %nS2 = findClosestPoint(cS, nSSet); nS2_c=nS2;
            nS2 = findfurthestPoint(cS, nSSet); nS2_c=nS2;
            if (numel(nS2)~=0)
                nS2=sub2ind(sz, nS2(1), nS2(2));
            end
            
            nS = [];
            % from the found seeds chose the one which make the orientation
            % of neurite as stable as possible.
            if (isempty(nS1) ==0 && isempty(nS2) == 0)
                d1=[nS1_c(1) nS1_c(2)]-[cSXY1 cSXY2];
                d1=d1(1)/d1(2); d1=atan(d1);
                d2=[nS2_c(1) nS2_c(2)]-[cSXY1 cSXY2];
                d2=d2(1)/d2(2); d2=atan(d2);
                n1=abs(d1-d); n2=abs(d2-d);
                
                if (min(n1,n2)<angBound)
                    if (n1<n2)
                        nS=nS1;
                    else
                        nS=nS2;
                    end
                end
                
            end
            if (isempty(nS1)==1)
                nS=nS2;
            end
            if (isempty(nS2)==1)
                nS=nS1;
            end
%        %%%      
       if(isempty(nS)==0)
           [nS_c1, nS_c2]=ind2sub(sz,nS);
                d1=[nS_c1 nS_c2]-[cSXY1 cSXY2];
                d1=d1(1)/d1(2); d1=atan(d1);
                n1=abs(d1-d);
                
                if (n1>angBound)
                    nS=[];
                    end
                end
                
          
% %%%
            
            idx = idx + 1;
            
            if (isempty(nS)==0)
                [nS_c1, nS_c2]=ind2sub(sz,nS);
                dist = sqrt((cS(1)-nS_c1)^2+ (cS(2)-nS_c2)^2);
            end
            
            %in order to prevent jumps from one neurite to another
            if (isempty(nS)==0)
                im=zeros(sz); im(cs)=1; im(nS)=1;
                bim=bwconvhull(im); bimc=bim.*neu;
                %figure; imshow(bim,[]);
                %figure; imshow(bimc,[]);
                if (numel(find(bimc))<numel(find(bim))-3)
                    nS=[];
                end
            end
            
            
            if (dist<distRangePixel && isempty(nS)==0)
                ty=0; 
            end
            
        end
        
    end
    s=s+1;
end
nS_ind=nS;
[nS1, nS2]=ind2sub(sz,nS);
nS=[nS1 nS2];
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017
