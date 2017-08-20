function selectedcomponents = findNeuriteComponents(S,xNeurites, xSeg, xSoma, dilatedSoma, D)
%initialization: this code is run for each soma regions. Each soma region
%is dilated in order to generate two rings around it. Then centroids are
%connected to find direction of neurite and starting point of trace.

se=strel('disk',6);
see=strel('disk',4);
dilatedSoma= imdilate(imdilate(imdilate(imdilate(dilatedSoma,see),see),see),see); %added new
dilatedSoma1=dilatedSoma;
for i=1:2
    dilatedSoma1 = imdilate(dilatedSoma1,se);
end
dilatedSoma2=dilatedSoma1;
for i=1:2
    dilatedSoma2 = imdilate(dilatedSoma2, se);
end
dilatedSoma3=dilatedSoma2;
for i=1:6
    dilatedSoma3 = imdilate(dilatedSoma3, se);
end

dilSomaB=dilatedSoma1; dilSomaB(dilatedSoma==1)=0;
dilSomaB1=dilatedSoma3; dilSomaB1(dilatedSoma2==1)=0;

neuMarks=dilSomaB.*double(xSeg); %nnm=neuMarks; nnm(S)=2;
%figure; imshow(nnm,[]) ;
neuMarks1=dilSomaB1.*double(xSeg); 
outerMarksCentroid =regionprops(neuMarks1,'centroid');

[B,~] = bwboundaries(neuMarks,'noholes');
cellLengths=cellfun('length',B); cellLengths=find(cellLengths>3);
BB=cell(length(cellLengths),1);
for i=1:length(cellLengths) BB{i,1}=B{cellLengths(i),1}; end
B=BB;
selectedcomponents=cell(length(B),1);

for i=1:length(B)
    if (length(B{i})>3)
        Bi=B{i};
        I = zeros(size(xNeurites));
        s_n=sub2ind(size(xSeg),Bi(:,1),Bi(:,2));
        I(s_n)=1; %figure; imshow(I,[]);
        pInNeurite = regionprops(I,'Centroid');
        pInNeurite=floor(pInNeurite.Centroid); pInNeurite=fliplr(pInNeurite);
        Si=[];
        for ii=1:length(S)
            [s1, s2]=ind2sub(size(xSeg),S(ii));
            Si=[Si; s1 s2];
        end
        [pInNeurite,~]=findClosestPoint(pInNeurite,Si);
        fSoma=bwboundaries(xSoma); fSoma=fSoma{1,1};
        %%
        fSoma_ind=sub2ind(size(xSeg),fSoma(:,1),fSoma(:,2));
        oM=ceil(outerMarksCentroid.Centroid); oM=fliplr(oM);
        dist=sqrt((pInNeurite(1)-oM(1))^2+(pInNeurite(2)-oM(2))^2);
        Img=zeros(size(xSoma));
        Img= long_line(Img,pInNeurite,oM,dist,0); 
        poss=intersect(find(Img),fSoma_ind);
        [p1,p2]=ind2sub(size(Img),poss); poss=[p1 p2];
        pInSoma=[];
        if (isempty(pInSoma)==1)
            [pInSoma,~]=findClosestPoint(pInNeurite,fSoma);
        end
        xTemp = zeros(size(xSeg));
        nbhBox = getLinearNeighborhood_p(size(xSeg), 4);
        reg = nbhBox + sub2ind(size(xSeg),pInSoma(1),pInSoma(2));
        distValInReg = D(reg);
        thk = ceil(max(distValInReg));
        cDist=sqrt((pInNeurite(1)-pInSoma(1))^2+(pInNeurite(2)-pInSoma(2))^2);
        xTemp=long_line(xTemp, pInNeurite,pInSoma,floor(0.7*cDist),thk);
        xSegmentToConnect = xTemp.*double(xSeg);
        g=xNeurites; g(find(xSegmentToConnect))=1;
        selectedComponents.neu=g;
        g(sub2ind(size(xSeg),pInNeurite(1),pInNeurite(2)))=3; g(sub2ind(size(xSeg),pInSoma(1),pInSoma(2)))=2; %%%figure; imshow(g,[])
        selectedComponents.pInNeurite=pInNeurite;
        selectedComponents.pInSoma=pInSoma;
        selectedcomponents{i}=selectedComponents; 
        %nnm(pInSoma(1), pInSoma(2))=3; nnm(pInNeurite(1), pInNeurite(2))=4; figure; imshow(nnm,[]);
    end
end


% Created by Cihan Kayasandik and Pooran Negi
%August 2017

