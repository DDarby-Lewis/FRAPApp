function [Bleach_Mask, Bleach_Boundary, instant] = bleachMaskAndBoundary(footage, cellMask, T, varargin)
%bleachMaskAndBoundary takes cell image and maps two outputs, a mask and a boundary
% Finds bleaching frame by calling bleachInstant.m function.
% 
% Created by Daniel Darby with thanks to Dr. Isabel Llorente Garcia.
% 
% Inputs:
% 
% footage is an the (corrected) 3D array of frames with time (frames) in
% the 3rd dimension
%  
% varargin:
% 
% avb = number of initial which MUST INCLUDE the initial post bleach frame
% and not too many after, esentially a guess at the position of the post 
% bleach frame (has to go first if included, otherwise defults to 25);
% 
% 'no' which cancles all input requests (must be first or second); 
% 
% 'clean' which removes all except the largest single object;
% 
% 'skel' which thins the boundary maximally with out disjoining; 
% 
% 'colour' followed by 'r', 'g' 'b' for red, green or blue images or any 
% 'c/c' combonation for differently coloured mask and boundary respectivly.
% 
% Outputs:
% 
% Bleach_Mask = a logical map with ones on the bleached area and zeros 
% everywhere else. 
% 
% Bleach_Boundary =  a logical map with ones on the edge of the cell and 
% zeros everywhere else.
%
% 
% i.e. using bleachMaskAndBoundary :
%
% bleachMaskAndBoundary(footage, cellMask)
% Returns the Bleach_Mask and Bleach_Boundary asking for input on threshold
% and using the automatic 25 frames for inclusive of bleaching.
%
% bleachMaskAndBoundary(footage, cellMask,'no')
% Returns Bleach_Mask and Bleach_Boundary without asking for input and 
% using the automatic 25 frames for inclusive of bleaching.
%
% bleachMaskAndBoundary(footage, cellMask, 15)
% Returns Bleach_Mask and Bleach_Boundary using the first 15 frames as 
% inclusive of the bleaching frame and asking for input on threshold.
%  
% bleachMaskAndBoundary(footage, cellMask, 15, 'no', 'clean', 'skel')
% Returns Bleach_Mask and Bleach_Boundary made from an using the first 15 
% frames as inclusive of the bleaching frame, removing all but the largest
% object in Bleach_Mask and thinning the Bleach_Boundary to one pixel,
% doesn't ask for input.
% 
% bleachMaskAndBoundary(footage, cellMask, 15, 'no', 'clean', 'skel', 'colour', 'r/b')
% Returns the Bleach_Mask in red and Bleach_Boundary in blue using the 
% first 15 frames as inclusive of the bleaching frame removing all but the 
% largest object in Bleach_Mask and thins the Bleach_Boundary to one pixel,
% won't ask for input.
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
    error('bMB:invar', 'Too many input arguments');
end

%% Initilise
len = size(footage,3);
f1 = footage(:,:,1);
zer = zeros(size(footage,1), size(footage,2));
% average for bleach
if isnumeric(varargin{1}) && ~isempty(varargin{1})
    avb = varargin{1};
elseif len < 25
    avb = len;
else
    avb = 25; % will auto set to 25
end

% average intensity map
aIm = mat2gray(sum(footage(:,:,1:avb),3).*cellMask);

%% Select first post bleach frame:

i = zer;
conI = zeros(1,len);
for p = 1:avb
    i = mat2gray(i + (mat2gray(footage(:,:,p).*cellMask) - aIm));
    conI(p) = sum(sum(i));
%     imshow(i); pause(0.1)
end

[~, instant] = max(gradient(conI));

frame = footage(:,:,instant);

%% Error Control: if frame entered isn't a sutiable image 
if ndims(frame) == 3 %takes a colour image and makes it an intensity image
    frame = 1/3*frame(:,:,1) + 1/3*frame(:,:,2) + 1/3*frame(:,:,3);
elseif ~ismatrix(frame);
    error('bMB:indim', 'Frame dimentions are not 2 (intensity) or 3 (RGB)');
end

frame = double(frame);%ensures frame is a double
frame = mat2gray(frame);%normalises the double frame

%% set the threashold for bleach and cell seperation
if ~strcmp(varargin{1}, 'no') && ~strcmp(varargin{2}, 'no')
    aorm = input('Bleach Mask and Boundary: \nAutomatic or user defined threshold? \n For manual enter any value between 0 and 1, for auto press any other key: \n', 's');
else
    aorm = [];
end
mT = str2double(aorm);
if mT >=0 && mT <= 1 %for manual threshold
    fprintf('Using %d as threshold value.\n', mT);
    T = mT;
elseif strcmp(varargin{1}, 'no') || strcmp(varargin{2}, 'no')
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
Mask = im2bw((f1.*cellMask - frame),T); %makes a binary image of the frame with all values above T becoming 1

Mask = imfill(Mask, 'holes'); %Fills in any gaps inside the cell which are below 1

%% Modify Outupts depending on input conditionals
if ~isempty(varargin{1}) || ~isempty(varargin{2}) %only applies if there were varargin from input
    if strcmp(varargin{1},'clean') || strcmp(varargin{2}, 'clean')|| strcmp(varargin{3}, 'clean')|| strcmp(varargin{4}, 'clean')
        Mask = bwmorph(bwmorph(bwmorph(Mask, 'close'), 'clean'), 'spur');
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
else
    Boundary = edge(Mask, 'canny'); %draws edge around firs output to make second
end
Bleach_Mask = Mask;
Bleach_Boundary = Boundary;


%% Adjust bleach instant
%for when the frame determined is off slightly
[~, instant] = min(sum(sum(bsxfun(@times,footage,Bleach_Mask))));
fprintf('First post bleach frame: %d \n', instant);

%% Tests
% 
% % shows images to display the bleach mask and boundary.
% close all
% 
% b = bwmorph(ones(size(f1,1),size(f1,2)),'remove');
% 
% figure, montage([b+Bleach_Mask, b+Bleach_Boundary])
% title({'Bleach Mask, Bleach Boundary'})
% 
% figure, montage([b+Bleach_Boundary + f1, b+Bleach_Boundary + footage(:,:,instant)])
% title('Bleach Boundary on First Image, Bleach Boundary on Photobleached Image')
% 
% % subplot('Position',[0,.5,.45,.45])
% % imshow(Bleach_Mask)
% % title('Bleach Mask')
% % 
% % subplot('Position',[.5,.5,.45,.45])
% % imshow(Bleach_Boundary)
% % title('Bleach Boundary')
% % 
% % subplot('Position',[0,0,.45,.45])
% % imshow(Bleach_Boundary + f1)
% % title('Bleach Boundary on First Image')
% % 
% % subplot('Position',[.5,0,.45,.45])
% % imshow(Bleach_Boundary + footage(:,:,instant))
% % title('Bleach Boundary on Photobleached Image')


end