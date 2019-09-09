function [Background_Mask] = backgroundMask(footage, T)
% takes FRAP footage and determines a sutiable region to use for the background
% 
% Inputs:
%   footage: corrected footage for FRAP data
%   T: optional and manual Threshold
% 
% Outputs:
%   Background_Mask: the area selected as not being the cell or any other
%   excessivly bright area. 
% 
% 

%% initial
cellMask = cellMaskAndBoundary(footage,[],'no');

nonCell = 1 - cellMask;

%tnCm is the total nonCell map of intensity
tm = (sum(footage,3));
tnCm = tm.*nonCell;

if nargin == 1 || isempty(T)
    T = graythresh(mat2gray(tm));
end  



% tbg = sum(sum(tnCm));
%avernC = sum(sum(tnCm))/l;% nonCell average

%% Cell Average
tI = sum(sum(tm.*cellMask));

averCell = (tI)/(sum(sum(cellMask)));

%% Whole not cell affected area calculation:

notCell = nonCell - ((tnCm - averCell) > -averCell*(1-T));%sets notCell to 1 wherever the mask is and where the background is above a threshold value

%% Select area of notCell for background:
Background_Mask = logical(im2bw(notCell,0));

%% Tests
 
% % shows images to display the bleach mask and boundary.
% close all
% 
% b = bwmorph(ones(size(f1,1),size(f1,2)),'remove');
% 
% figure, imshow(Background_Mask)
% title('Background Mask')
% 
% figure, montage([b+footage(:,:,1),Background_Mask+ footage(:,:,1)])
% title('Background Mask (at half intensity) on First Image')

% Plot area

% I = zeros(l,1);
% for k =1:l
%     I(k) = sum(sum(footage(:,:,k).*background_Mask));
% end
% 
% plot(1:l, (I)/(sum(sum(background_Mask))));

end