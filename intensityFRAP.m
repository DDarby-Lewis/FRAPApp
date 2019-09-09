function [varargout] = intensityFRAP(footage, bleachMask, instant, cellMask, bgMask, varargin)
% Returns raw, double or full normalised function of intensity
% Inputs:
% 
% footage = the (corrected) structure of frames under field 'image'
% 
% varargin: 
% 
%   aver = number of initial frames to average over (has to go
%   first if included, otherwise defults to 1) for cellMaskAndBoundary function; 
% 
%   avb = number of initial which MUST INCLUDE the initial post bleach frame
%   and not too many after, esentially a guess at the position of the post 
%   bleach frame (has to go second if included, otherwise defults to 25);
% 
% Redundant:
% %   'double' can go first second or third, indicates the first output returned
% %   to be double normalised data
% % 
% %   'full' can go first second or third, indicates the first output returned
% %   to be full normalised data
% % 
% 
%   'outliers' returns data with suspected outliers removed.
% 
% Output: 
%       vargout{1} = raw bleach spot intensity
%       vargout{2} = whole cell intensity
%       vargout{3} = background intensity
%       vargout{4} = double intensity
%       vargout{5} = full intensity
% 
% Redundant:
% %        no varargin gives 3:
% %        first, Intensity in FRAP region; second, Intensity in whole cell; 
% %        and third is intensity in background.
% %        varargin 'double' returns double normalised data in place of the
% %        first output FRAP ROI intensity. 
% %        varargin 'full' returns full normalised data in place of the
% %        first output FRAP ROI intensity. 
% 

%% Error Control:  The following prevent errors from using more than 1 input.

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

if length(varargin) > 5
    error('inFRAP:invar', 'Too many input arguments');
end

%% Initilise

len = length(footage);

% Average for cellMask:
if ~isempty(varargin{1}) && isnumeric(varargin{1})
    avc = varargin{1};
else
    avc = 1;
end

% Guess for bleachMask:
if ~isempty(varargin{2}) && isnumeric(varargin{2})
    avb = varargin{2};
else
    avb = [];
end



%% Call functions to get all masks:

% add second inputs cellBoundary and bleachBoundary respecitvly to the
% following functions to run final tests
if isempty(cellMask)
    [cellMask, ~] = cellMaskAndBoundary(footage, avc, 'no', 'clean');
end
if isempty(bleachMask)
    [bleachMask, ~ , instant] = bleachMaskAndBoundary(footage, cellMask, avb, 'no', 'clean');
end
if isempty(bgMask)
    bgMask = backgroundMask(footage);
end

%% Make intensity against time curves

% Finds intensity in FRAP area per frame and divides by FRAP area
I_b(1,:) = sum(sum(bsxfun(@times,footage,bleachMask),1),2)/(sum(sum(bleachMask))); 

% Finds intensity in cell per frame and divides by cell area
I_c(1,:) = sum(sum(bsxfun(@times,footage,cellMask),1),2)/(sum(sum(cellMask))); 

% Finds intensity in backgroung per frame and divides by background area
I_bg(1,:) = sum(sum(bsxfun(@times,footage,bgMask),1),2)/(sum(sum(bgMask))); 

I_1 = I_b - I_bg; % subtracting the background from ROI1 
I_2 = I_c - I_bg; % subtracting the background from ROI2

%% Catching outliers
if strcmp(varargin{1},'outliers') || strcmp(varargin{2},'outliers') || strcmp(varargin{3},'outliers')
    % catch outliers for whole cell and background with > 20% varation
    for k =t  
        if I_c(k)> 1.2*sum(I_c)/len && I_bg(k)> 1.2*sum(I_bg)/len || ...
                I_c(k)< 0.8*sum(I_c)/len && I_bg(k)< 0.8*sum(I_bg)/len
            
            I_c(k) = sum(I_c)/len;
            fprintf('Outlier: removed frame %i from whole cell function \n', k)
            I_bg(k) = sum(I_bg)/len;
            fprintf('Outlier: removed frame %i from background function \n', k)
        end
    end
end  
%% handle normalisation methods for output

% return the background curve:
varargout{3} = I_bg;
% return the whole cell curve
varargout{2} = I_c;
% calculate the pre bleach average for whole cell
Ipre_2 = sum(I_2(1:(instant-1)))/(instant-1);

% and for FRAP region
Ipre_1 = sum(I_1(1:(instant-1)))/(instant-1);
% Double Normalisation:
Idouble = (Ipre_2/Ipre_1)*(I_1./I_2);

varargout{4} = Idouble;
Ifull = (Idouble - Idouble((instant)))/(1 - Idouble((instant)));
varargout{5} = Ifull;
varargout{1} = I_b;

%% Plot area
% close all
% 
% f1 = footage(1).image;
% 
% b = bwmorph(ones(size(f1,1),size(f1,2)),'remove');
% 
% figure, montage([b + f1,(b~=1).*( + f1 + cellBoundary+ bleachBoundary + bgMask),...
%     b + footage(instant).image + cellBoundary + bleachBoundary + bgMask/2])
% title('First Image;   Cell Boundary + Bleach Boundary + Background Mask on First Image;   Cell Boundary + Bleach Boundary + Background Mask (at half intensity) on Photobleached Image')
% 
% %plot all on same plot
% figure, subplot('Position', [0.03,0.045,.45,.9])
% plot(t,I_b, t,I_c, t,I_bg);
% title('Raw Intensity Curves')
% subplot('Position', [0.53,0.045,.45,.9])
% plot(t,I_1, t,I_2, t,I_bg - I_bg);
% title('Background Subtracted Intensity Curves')
% set(gcf, 'Position', [100,100,1000,400])
