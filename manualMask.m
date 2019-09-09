function [Mask, Boundary] = manualMask(shape,width,image)
%This function is used to select a bleach mask manually

if strcmp(shape,'circular')
    imshow(image);
    [x,y] = ginput(1);
    [columnsInImage,rowsInImage] = meshgrid(1:size(image,2), 1:size(image,1));
    Mask = (rowsInImage - y).^2 +(columnsInImage - x).^2 <= width(1).^2;
    Boundary = bwmorph(Mask,'remove');
    
elseif strcmp(shape,'rectangular')
    if isempty(width(3))||isnan(width(3))
        width(3) = 0;
    end

    imshow(image);
    [x,y] = ginput(1);
    
    ret(1:width(2),1:width(1)) = 1;
    ret = imrotate(ret,width(3));
    cen = regionprops(ret,'centroid');cen = cen.Centroid;
    
    ystart = ceil(y-size(ret,1)/2);
    yend = floor(y+size(ret,1)/2);
    xstart = ceil(x-size(ret,2)/2);
    xend = floor(x+size(ret,2)/2);
        
    rystart = 1;
    ryend = size(ret,1);
    rxstart = 1;
    rxend = size(ret,2);
    
    if size(ret,1)>size(image,1)
        ret = ret(1:size(image,1),:);
    end
    if size(ret,2)>size(image,2)
        ret = ret(:,1:size(image,1));
    end
    
    if yend>size(image,1)
        ryend = floor(size(ret,1)+size(image,1)-yend);
        yend = size(image,1);
    end
    if xend>size(image,2)
        rxend = floor(size(ret,2)+size(image,2)-xend);
        xend = size(image,2);
    end
    if ystart<1
        rystart = 2-ystart;
        ystart = 1;
    end
    if xstart<1
        rxstart = 2-xstart;
        xstart = 1;
    end
    Mask = zeros(size(image,1),size(image,2));
    Mask(ystart:yend,xstart:xend) = ret(rystart:ryend,rxstart:rxend);
    Boundary = bwmorph(Mask,'remove');
end