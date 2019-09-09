function playVid(footage, start_end, OoE,fps,h,progress)
% playVid Forms a series or images which display like a slide show of all the frames in the footage input.
%
% Inputs:
% footage: this can be either the corrected or uncorrected footage, any
% series of images in a strcture under the field 'image' will be read.
%
% start_end is a 1x2 vector containing the starting frame and ending frame
% on which the footage will start playing from and end playing on as in : 
% start_end = [start_frame,end_frame].
% If start_end is empty or not specified it is set to go from the inital
% frame in footage to the final frame. If the end_frame exceeds the length
% of the footage then it is set to the length of the footage. 
%
% OoE stands for Odd or Even and specifices if all the even numbered frames
% or odd numbered frames should be played, valid inputs are:
% OoE = 'odd' (plays odd frames) or 'even' (plays even frames) or no input
%(for both odd and even frames).
% For OoE = 'odd' or 'even' the length of played footage between 
% start_frame and and _frame is cut in half and the respective odd or even
% frame numbers will display
%
% NB: there is no need or effect in terminating this function with a ";".
%
% i.e. using playVid :
%
% playVid(footage)
% will play footage from start to end
%
% playVid(footage,[1,100])
% will play footage from 1 to 100 (or the max of footage if less than 100).
%
% playVid(footage, [1, 100], 'odd')
% will play odd frames from 1 to 99 (or the odd max if less than 100).
% 
% playVid(footage, [1, 100], 'even')
% will play even frames from 2 to 100 (or the even max if less than 100).
% 

%% Initialise
% set initial variables and conditions
if nargin < 6
    progress = 0;
end
if nargin < 5
    h = gcf;
end
if nargin < 4
    fps = 25;
end
% For not including input OoE
if nargin < 3
    OoE = 0;
end

% For not including start_frame and/or end_frame
if nargin < 2 || isempty(start_end)
    end_frame = size(footage,3);
    start_frame = 1;
else
    start_frame = start_end(1);
    end_frame = start_end(2);    
end

%% Error control:
% for inputs longer than footage length
if end_frame > size(footage,3)
    end_frame = size(footage,3);
end
if start_frame > end_frame
    error('pV:se', 'Starting frame cannot be after the ending frame');
end

%% Function Body
if progress ~=0
    axes(progress)
    bar = zeros(end_frame,end_frame,3);
    image(bar);axis off
end 
for p = start_frame:end_frame
    if strcmp(OoE,'odd') && mod(p,2) ~= 0
        disp(['frame number: ',num2str(p)]) % print frame number to Command Window.
        axes(h);
        imshow(footage(:,:,p),[],'Border','tight')%,'InitialMagnification',150);
        title(['Frame: ', num2str(p)]);
        pause(2/(fps));
        if progress ~=0
            axes(progress);
            bar(:,start_frame:p,1) = .95;
            bar(:,start_frame:p,2:3) = .65;
            image(bar);axis off
        end       
    elseif strcmp(OoE,'even')&& mod(p,2) == 0
        disp(['frame number: ',num2str(2*p)]) % print frame number to Command Window.
        axes(h);
        imshow(footage(:,:,p),[],'Border','tight')%,'InitialMagnification',150);
        title(['Frame: ', num2str(p)]);
        pause(2/(fps));
        if progress ~=0
            axes(progress);
            bar(:,start_frame:p,1) = .95;
            bar(:,start_frame:p,2:3) = .65;
            image(bar);axis off
        end
    elseif ~strcmp(OoE,'odd') && ~strcmp(OoE,'even')
        disp(['frame number: ',num2str(p)]) % print frame number to Command Window.
        axes(h);
        imshow(footage(:,:,p),[],'Border','tight')%,'InitialMagnification',150);
        title(['Frame: ', num2str(p)]);
        pause(1/(fps));
        if progress ~=0
            axes(progress);
            bar(:,start_frame:p,1) = .95;
            bar(:,start_frame:p,2:3) = .65;
            image(bar);axis off
        end
    end
end
end