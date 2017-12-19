function [densityMap]=densityEstimate(segm,image_red, neuriteGraph,D,patchSize)
% collect intensity measurements with subtracting estimated background
% intensity

%segm: segmented binary image
%image_red: image channel which will be used for measurements extraction
%neuriteGraph: extracted tree structure
% D: Density map of input image
% patchSize: size of boxes to estimate background intensity

sD=size(D); sD1=sD;
%zero padding
zero_base=zeros(sD(1)+200,sD(2)+200);
zero_base(100:sD(1)+99,100:sD(2)+99)=D;
D=zero_base;
zero_base=zeros(sD(1)+200,sD(2)+200);
zero_base(100:sD(1)+99,100:sD(2)+99)=segm;
segm_s=zero_base;

segm=zero_base;
segm=segm-1; segm(segm==-1)=1;

zero_base=zeros(sD(1)+200,sD(2)+200);
zero_base(100:sD(1)+99,100:sD(2)+99)=image_red;
image_red=zero_base;
sD=size(image_red);

ss=length(neuriteGraph);
densityMap=cell(ss,1);

for i=1:ss
    neuG=neuriteGraph{i};
    neuLen=length(neuG);
    dens_d=cell(neuLen,1);
    for j=1:neuLen
        neuGd=neuG{j};
        points=length(neuGd);
        I=zeros(1,points);
        for k=1:points
            if (k<points)
                radius=D(neuGd(k))+4;%+8; %distance between background patches and seed point
                ind1=neuGd(k); ind2=neuGd(k+1);
            else
                radius=D(neuGd(k))+4;%+8; %distance between background patches and seed point
                ind1=neuGd(k); ind2=neuGd(k-1);
            end
            
            [sub11,sub12]=ind2sub(sD1,ind1);  sub11=sub11+100; sub12=sub12+100;
            [sub21,sub22]= ind2sub(sD1,ind2); sub21=sub21+100; sub22=sub22+100;
            dy= (sub22-sub12); dx=(sub21-sub11);
            %create patches to estimate background intensity
            n1=[sub11+ceil(radius)*dy sub12-ceil(radius)*dx]; n2=[sub11-ceil(radius)*dy sub12+ceil(radius)*dx];
            if (dy==0)
                n1=[sub11+ceil(radius)*dy sub12-ceil(radius)]; n2=[sub11-ceil(radius)*dy sub12+ceil(radius)];
                
            end
            if (dx==0)
                n1=[sub11+ceil(radius) sub12-ceil(radius)*dx]; n2=[sub11-ceil(radius) sub12+ceil(radius)*dx];
            end
            
            
            n_base=zeros(sD); n_base(n1(1),n1(2))=1; n_base(n2(1),n2(2))=1;
            n_B=bwconvhull(n_base);
            I2=image_red.*(double(n_B).*segm); %eliminate foreground points
            I1=image_red.*(double(n_B).*segm_s); %eliminate background points
            if (numel(find(I2))<2)
                I(k)=-1;
            else
                I(k)=sum(I1(:))-numel(find(I1))*(sum(abs(I2(:)))/max(1,numel(find(I2)))); %background subtraction
                
            end
        end
        
        dens_d{j}=I;
    end
    densityMap{i}=dens_d;
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017
