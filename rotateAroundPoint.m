function [xTemp_r]=rotateAroundPoint(xTemp, rotAngle, center,sz)
% rotates image xTemp around point center with angle rotAngle. 
%sz is size of input image xTemp.
cntr=[sz/2];
diff=center-cntr;
trs_im=imtranslate(xTemp,fliplr(-diff));
M1 = [cosd(rotAngle) sind(rotAngle) 0; -sind(rotAngle) cosd(rotAngle) 0; 0 0 1];

tform=affine2d(M1);
xTemp1 = imwarp(trs_im, tform);

diffs=size(xTemp1)-sz;
half_diff=floor(diffs/2);
half_diff=[min(max(1,half_diff(1)),sz(1)) max(min(half_diff(2),sz(2)),1)];
xTemp1_n=xTemp1(half_diff(1):half_diff(1)+sz(1)-1,half_diff(2):half_diff(2)+sz(2)-1);
xTemp_r=imtranslate(xTemp1_n,fliplr(diff));
end



