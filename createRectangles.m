function cell_inc=createRectangles(lengthToSearch,othk, lenIncrStep, nBands,sz)
% creates rectangular filters at each integer angle: 360 filters in total.
% filters are created with varying lengths to use in different steps of the
% algorithm

%INPUT:
%lengthToSearch: filter length,
%othk: filter width,
%lenIncrStep: number of increments,
%nBands: number of orientation which is used in algorithm,
%sz: size of input.


cell_idx=cell(nBands/2,1);
cell_inc=cell(lenIncrStep,1);
for s=1: lenIncrStep
    length = lengthToSearch + 4.0*((s-1.0)*lengthToSearch)/lenIncrStep;
    thk= othk + 1*(s*othk)/(lenIncrStep);
    for idx =0: nBands/2-1
        length = length/(1.0+ 1.0*idx/nBands)^2;
        
        sec=cell(360,1);
        t=1;
        
        for i=91:179
            
            dd=[tand(i) 1]; dr = sqrt(dot(dd', dd));
            rectangle=getRectangle_alt(sz/2,dd,dr,length,thk,sz);
            %figure; imshow(rectangle,[]);
            sec{t}=rectangle;
            t=t+1;
            
        end
        rectangle=getRectangle_alt(sz/2, [0 length], length,length, thk, sz);
        sec{t}=rectangle;
        t=t+1;
        for i=1:89
            
            dd=[tand(i) 1]; dr = sqrt(dot(dd', dd));
            rectangle=getRectangle_alt(sz/2,dd,dr,length,thk,sz);
            %figure; imshow(rectangle,[]);
            sec{t}=rectangle;
            t=t+1;
            
        end
        
        rectangle=getRectangle_alt(sz/2, [length 0], length,length, thk, sz);
        sec{t}=rectangle;
        t=t+1;
        for i=91:179
            
            dd=[-tand(i) -1]; dr = sqrt(dot(dd', dd));
            rectangle=getRectangle_alt(sz/2,dd,dr,length,thk,sz);
            %figure; imshow(rectangle,[]);
            sec{t}=rectangle;
            t=t+1;
            
        end
        rectangle=getRectangle_alt(sz/2, [0 -length], length,length, thk, sz);
        sec{t}=rectangle;
        t=t+1;
        for i=1:89
            
            dd=[-tand(i) -1]; dr = sqrt(dot(dd', dd));
            rectangle=getRectangle_alt(sz/2,dd,dr,length,thk,sz);
            %figure; imshow(rectangle,[]);
            sec{t}=rectangle;
            t=t+1;
            
        end
        rectangle=getRectangle_alt(sz/2, [length 0], length,length, thk, sz);
        sec{t}=rectangle;
        cell_idx{idx+1}=sec;
    end
    cell_inc{s}=cell_idx;
    
end


% Created by Cihan Kayasandik
%August 2017
