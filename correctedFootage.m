function [corrected_Footage] = correctedFootage(footage, start_end, crp, OoE)
% correctedFootage returns eddited data with only useful frames
% This crops and cuts footage and keeps only odd or even frames for .mvd2
% footage which contains noninformation frames.
%
% Inputs:
% footage: This is the uncorrected footage, a 3D array with time (frames) 
% along the 3rd axis.
%
% start_end is a 1x2 vector containing the starting frame and ending frame
% on which the footage will be complied into the corrected_Footage as in : 
% start_end = [start_frame,end_frame].
% If start_end is empty or not specified it is set to go from the inital
% frame in footage to the final frame. If the end_frame exceeds the length
% of the footage then it is set to the length of the footage. 
% 
% crp is a 1x4 vector specifying [xmin, ymin, width, height], see imcrop
% doc for more help. crp can be left empty for no croping.
% 
% OoE stands for Odd or Even and specifices if all the even numbered frames
% or odd numbered frames should be kept, valid inputs are:
% OoE = 'odd' (plays odd frames) or 'even' (plays even frames) or no input
%(for both odd and even frames). This is useful in removing dud even frames
% in .mvd2 files.
% For OoE = 'odd' or 'even' the length of played footage between 
% start_frame and and _frame is cut in half and the respective odd or even
% frame numbers will display
%
% i.e. using correctedFootage :
%
% correctedFootage(footage)
% will play footage from start to end
%
% correctedFootage(footage,[1,100])
% will cut footage from frame 1 to 100 (or max of footage if less than 100)
%
% correctedFootage(footage, [], [2,4,3,5])
% Will crop footage from x = 2 to x = 2+3 = 5 and from y = 4 to y = 4+5 = 9
%  
% correctedFootage(footage, [],[], 'odd')
% will cut from start to end keeping only odd frames.
% 

%% Initilisation
l = size(footage,3);

if nargin < 4
    OoE = 0;
end
if nargin < 3 || isempty(crp)
    crp = []; %[xmin ymin width height]
else
    if crp(1)+crp(3)-1 > size(footage,1);
    crp(3) = size(footage,1) - crp(1);
    end
    if crp(2)+crp(4)-1 >  size(footage,2);
    crp(4) = size(footage,2) - crp(2);
    end
end
if nargin < 2 || isempty(start_end)
    end_frame = l;
    start_frame = 1;
else
    start_frame = start_end(1);
    end_frame = start_end(2);    
end

%% Error control: for inputs longer than footage length
if end_frame > l
    end_frame = l;
end
if start_frame > end_frame
    error('cF:se', 'Starting frame cannot be after the ending frame');
end

%% Use OoE to remove duds, Cut footage with startend and crop with crp

evenv = mod(1:l,2)==0;% logical indexing for even frames

if strcmp(OoE, 'odd')
    cutfootage = footage(:,:,(evenv(start_frame:end_frame)==0));

elseif strcmp(OoE, 'even')
    cutfootage = footage(:,:,evenv(start_frame:end_frame));

else
    cutfootage = footage(:,:,start_frame:end_frame); 

end

% crop footage:
if isempty(crp) || crp(1) == 1 && crp(2)==1 && crp(3)==size(footage,1) && crp(4)==size(footage,2)
    corrected_Footage = cutfootage;
else
    corrected_Footage = cutfootage(crp(1):(crp(1)+crp(3)-1),crp(2):(crp(2)+crp(4)-1),:);    
end

%% Tests

% % Shows what the footage was like originally compared to after correction:
% 
% playVid(footage,[1,20])
% 
% pause(3)
% 
% playVid(corrected_Footage, [1,10])


end