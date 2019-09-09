function [Cell_Mask, Cell_Boundary] = cellMaskAndBoundary(footage,T, varargin)
%cellMaskAndBoundry takes cell image and maps two outputs, a mask and a boundry
% 
% Created by Daniel Darby with thanks to Dr. Isabel Llorente Garcia.
% 
% Inputs:
% 
% footage = the (corrected) footage, a series of images in a 3D array with
% time (frames) along the 3rd axis.
% 
% varargin: 
% 
% aver = number of initial frames to average over (has to go
% first if included); 
% 
% 'no' which cancles all input requests (must be first
% or second); 
% 
% 'clean' which removes all except the largest single object;
% 
% 'skel' which thins the boundary maximally with out disjoining; 
% 
% 'colour' followed by 'r', 'g' 'b' for red green or blue images or any
% 'c/c' combonation for differently coloured mask and boundary respectivly.
%
% Outputs:
% 
% Cell_Mask = a logical map with ones on the cell body and zeros everywhere
% else. 
% 
% Cell_Boundary =  a logical map with ones on the edge of the cell and 
% zeros everywhere else.
% 
% 
% i.e. using cellMaskAndBoundary :
%
% cellMaskAndBoundary(footage)
% Returns the Cell_Mask and Cell_Boundary asking for input on threshold.
%
% cellMaskAndBoundary(footage,'no')
% Returns Cell_Mask and Cell_Boundary without asking for input.
%
% cellMaskAndBoundary(footage, 3)
% Returns Cell_Mask and Cell_Boundary made from an average of the first 3 
% frames and asking for input on threshold.
%  
% cellMaskAndBoundary(footage, 5, 'no', 'clean', 'skel')
% Returns Cell_Mask and Cell_Boundary made from an average of the first 5 
% frames removing all but the largest object in Cell_Mask and thinning the
% Cell_Boundary to one pixel, doesn't ask for input.
% 
% cellMaskAndBoundary(footage, 5, 'no', 'clean', 'skel', 'colour', 'r/b')
% Returns the Cell_Mask in red and Cell_Boundary in blue made from an 
% average of the first 5 frames removing all but the largest object in 
% Cell_Mask and thins the Cell_Boundary to one pixel, won't ask for input.
% 

%% Error Control:  The following prevent errors from using more than 1 input.
if length(varargin) > 1
    varargin{6} = varargin{end};
end
if length(varargin) < 5
    varargin{5} = [];
end
if length(varargin) < 4
    varargin{4} = [];
end
if length(varargin) < 3
    varargin{3} = [];
end
if length(varargin) < 2
    varargin{2} = [];
end
if length(varargin) < 1 %this occurs if there are no varargin
    varargin{1} = [];
end

if length(varargin) > 6
    error('cMB:invar', 'Too many input arguments');
end

%% Average first n frames:
if isnumeric(varargin{1}) && ~isempty(varargin{1})
    Tframe = sum(footage(:,:,1:varargin{1}),3);
    frame = Tframe/varargin{1};
else
    frame = footage(:,:,1);
end


%% Error Control: if frame entered isn't a sutiable image 
if ndims(frame) == 3 %takes a colour image and makes it an intensity image
    frame = 1/3*frame(:,:,1) + 1/3*frame(:,:,2) + 1/3*frame(:,:,3);
elseif ~ismatrix(frame);
    error('cMB:indim', 'Frame dimentions are not 1 (intensity) or 3 (RGB)');
end

frame = double(frame);%ensures frame is a double
frame = mat2gray(frame);%normalises the double frame

%% set the threashold for cell and background seperation
if ~strcmp(varargin{1}, 'no') && ~strcmp(varargin{2}, 'no')
    aorm = input('Whole Cell Call: \nAutomatic or user defined threshold? \n For manual enter any value between 0 and 1, for auto press any other key: \n', 's');
else
    aorm = [];
end
mT = str2double(aorm);
if mT >=0 && mT <= 1 %for manual threshold
    fprintf('Using %d as threshold value.\n', mT);
    T = mT;
elseif strcmp(varargin{1}, 'no') || strcmp(varargin{2}, 'no')% no requests
    if isempty(T)
        T = (graythresh(frame));
    end
else %for auto threshold
    modi = input('Do you wish to modify threshold? modify by power: ','s' );
    mod = str2double(modi);
    if isnumeric(mod) && ~isnan(mod) && mod > 0
        fprintf('Using threshold modifier: modifer =  %d \n', mod);
    else
        mod = 1;
    end
    T = (graythresh(frame))^mod;
    fprintf('Using automatic threshold: T = %d.\n', T);
end

%% Calculate outputs 
Mask = im2bw(frame,T); %makes a binary image of the frame with all values above T becoming 1

Mask = imfill(Mask, 'holes'); %Fills in any gaps inside the cell which are below 1

Boundary = edge(Mask, 'canny'); %draws edge around firs output to make second

%% Modify Outupts depending on input conditionals
if ~isempty(varargin{1}) || ~isempty(varargin{2}) %only applies if there were varargin from input
    if strcmp(varargin{1},'clean') || strcmp(varargin{2}, 'clean')|| strcmp(varargin{3}, 'clean')|| strcmp(varargin{4}, 'clean')
        Mask = bwmorph(bwmorph(Mask, 'clean'), 'spur');
        CMask = bwconncomp(Mask);
        sizMask = cellfun(@numel,(CMask.PixelIdxList));
        [~,idM] = max(sizMask);
        Mask = false(size(Mask));
        Mask(CMask.PixelIdxList{idM}) = true;
        Mask = imfill(Mask, 'holes');
        
        Boundary = edge(Mask, 'canny');%allows the cleaned image to be used for boundary.
    end
    if strcmp(varargin{1}, 'skel')||strcmp(varargin{2}, 'skel')||strcmp(varargin{3}, 'skel')||strcmp(varargin{4}, 'skel')
        Boundary = bwmorph(bwmorph(bwmorph(Boundary, 'bridge'), 'skel'), 'clean');
        CBoundary = bwconncomp(Boundary);
        sizBoundary = cellfun(@numel,(CBoundary.PixelIdxList));
        [~,idB] = max(sizBoundary);
        Boundary = false(size(Boundary));
        Boundary(CBoundary.PixelIdxList{idB}) = true;
    end
    if strcmp(varargin{1}, 'colour')||strcmp(varargin{2}, 'colour')||strcmp(varargin{3}, 'colour')||strcmp(varargin{4}, 'colour')
        Mask = im2double(Mask);
        Boundary = im2double(Boundary);
        LFrame = Mask;
        Line = Boundary;
        Mask(:,:,1:3) = 0;
        Boundary(:,:,1:3) = 0;
        switch varargin{end}
            case 'r'
                Mask(:,:,1) = LFrame;
                Boundary(:,:,1) = Line;
            case 'g'
                Mask(:,:,2) = LFrame;
                Boundary(:,:,2) = Line;
            case 'b'
                Mask(:,:,3) = LFrame;
                Boundary(:,:,3) = Line;
            case 'r/g'
                Mask(:,:,1) = LFrame;
                Boundary(:,:,2) = Line;
            case 'r/b'
                Mask(:,:,1) = LFrame;
                Boundary(:,:,3) = Line;
            case 'g/b'
                Mask(:,:,2) = LFrame;
                Boundary(:,:,3) = Line;
            case 'g/r'
                Mask(:,:,2) = LFrame;
                Boundary(:,:,1) = Line;
            case 'b/r'
                Mask(:,:,3) = LFrame;
                Boundary(:,:,1) = Line;
            case 'b/g'
                Mask(:,:,3) = LFrame;
                Boundary(:,:,2) = Line;
        end
    end
end
Cell_Mask = Mask;
Cell_Boundary = Boundary;

%% Tests
% 
% % shows images to display the cell mask and boundary.
% close all
% 
% b = bwmorph(ones(size(f1,1),size(f1,2)),'remove');
% 
% figure, montage([b+Cell_Mask,Cell_Boundary+b])
% title('Cell Mask, Cell Boundary')
% 
% figure, montage([b+Cell_Mask .* f1,b+Cell_Boundary + f1])
% title('Cell Mask times first image, Cell Boundary on first image')
% 
% % subplot('Position',[0,.5,.45,.45])
% % imshow(Cell_Mask)
% % title('Cell Mask')
% % 
% % subplot('Position',[.5,.5,.45,.45])
% % imshow(Cell_Boundary)
% % title('Cell Boundary')
% % 
% % subplot('Position',[0,0,.45,.45])
% % imshow(Cell_Mask .* f1)
% % title('Cell Mask times first image')
% % 
% % subplot('Position',[.5,0,.45,.45])
% % imshow(Cell_Boundary + f1)
% % title('Cell Boundary on first image')
end