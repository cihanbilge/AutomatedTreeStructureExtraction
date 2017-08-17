function [densityMap]=densityEstimate(image_red, neuriteGraph,D,patchSize)
% collect intensity measurements with subtracting estimated background
% intensity

sD=size(D); sD1=sD;
%zero padding
zero_base=zeros(sD(1)+200,sD(2)+200);
zero_base(100:sD(1)+99,100:sD(2)+99)=D;
D=zero_base;
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
                radius=D(neuGd(k))-2;
                ind1=neuGd(k); ind2=neuGd(k+1);
            else
                radius=D(neuGd(k))-2;
                ind1=neuGd(k); ind2=neuGd(k-1);
            end
            
            [sub11,sub12]=ind2sub(sD1,ind1);  sub11=sub11+100; sub12=sub12+100;
            [sub21,sub22]= ind2sub(sD1,ind2); sub21=sub21+100; sub22=sub22+100;
            dy= (sub22-sub12); dx=(sub21-sub11);
            %slope= -1/slope;
            n1=[sub11+ceil(radius)*dy sub12-ceil(radius)*dx]; n2=[sub11-ceil(radius)*dy sub12+ceil(radius)*dx];
            n_base=zeros(sD); n_base(n1(1),n1(2))=1; n_base(n2(1),n2(2))=1;
            n_B=bwconvhull(n_base);%Coordinate_i
            distanc=radius+2;
            %create patches to estimate background intensity
            patch1_start=[sub11+ceil(distanc)*dy sub12-ceil(distanc)*dx];
            patch1_end=[sub11+ceil(distanc+patchSize(2))*dy sub12-ceil(distanc+patchSize(2))*dx];
            z1=zeros(sD); z1(patch1_start(1),patch1_start(2))=1;z1(patch1_end(1),patch1_end(2))=1; z1=bwconvhull(z1);
            patch2_start=[sub11-ceil(distanc)*dy sub12+ceil(distanc)*dx];
            patch2_end=[sub11-ceil(distanc+patchSize(2))*dy sub12+ceil(distanc+patchSize(2))*dx];
            z2=zeros(sD); z2(patch2_start(1),patch2_start(2))=1;z2(patch2_end(1),patch2_end(2))=1; z2=bwconvhull(z2);
            ssm=strel('square',3); 
            z1=imdilate(z1,ssm,'same');
            z2=imdilate(z2,ssm,'same');
            I21=image_red.*double(z1);
            I22=image_red.*double(z2);
            I1=image_red.*double(n_B);
           
            if (numel(find(I21))~=0 && (abs(sum(I1(:))/numel(find(I1))-sum(I21(:))/numel(find(I21)))<1000))
                I21=zeros(size(I1));
            end
            if (numel(find(I22))~=0 && (abs(sum(I1(:))/numel(find(I1))-sum(I22(:))/numel(find(I22)))<1000))
                I22=zeros(size(I1));
            end
             I2=I21+I22;   
                
            I(k)=sum(I1(:))-sum(abs(I2(:)))/max(1,numel(find(I2)));
            k=k+1;
        end
        
        dens_d{j}=I;
    end
    densityMap{i}=dens_d; 
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017