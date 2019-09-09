%Script which should effectively run the included functions
% this script was written in a text editor not MATLAB editor and so may
% need checking before it runs properly


%% Import Data
% first thing to do is to import the data from the .mvd2 file from Mark 
% Marsh Data. The following invokes a modified bfopen.m included in the 
% zip folder

[f1, dF1] = getFootage('N:\FRAP\Data\FRAP_data_MarkMarsh\220611.mvd2');
% this will automatically open the first series of data and return a 
% f1 = footage frames in structure under 'image' field and dF1 = all
% supplimentary data on f1, see help Doc on getFootage for more help

%n = input('what series would you like? : \n'); 
% input number for the desired series, try 9 maybe?

%[fn, dFn] = getFootage('N:\FRAP\Data\FRAP_data_MarkMarsh\220611.mvd2', n); 
%retrives data series n


%% Correct Footage
% the supplied .mvd2 data has a major flaw, every even numbered frame in 
% all the series I have viewed is useless.Not all the series included
% (71 in total) are actually cell footage, some are graphs etc.

%playVid(f1,1,100); % show flawed data from frame 1 to 100

% playVid(fn,1,100); % use this if you wish to see the other series you chose

cf1 = correctedFootage(f1, [1,100],[],'odd'); 

% Cuts to the first 100 frames and then keeps only the odd numbered frames.
% [] is an option for cropping footage, see help doc on correctedFootage.

% cfn = correctedFootage(fn, [1,100],[],'odd'); % use for series n


%% Get Mask and Boundary for the whole cell

aver = input('number of initial frames to use for average? : \n');

[cellMask1, cellBoundary1] = cellMaskAndBoundary(cf1,aver,'clean','skel');

% the input aver is used to form an image of the cell over the first aver 
% frames giving a more uniform/consistent image. The input 'clean' takes
% away all except the largest connected object in the image and 'skel'
% thins the boundary to single pixel. Colour can also be added and the user
% input for threshold supressed see help doc for more.

% [cellMaskn, cellBoundaryn] = cellMaskAndBoundary(fn,aver,'clean', 'skel');


%% Get Bleach Mask And Boundary

[bleachMask1, bleachBoundary1] = bleachMaskAndBoundary(cf1,cellMask,'clean','skel');
% operates similarly to cellMaskAndBoundary except requires cellMask as an input.

% [bleachMaskn, bleachBoundaryn] = bleachMaskAndBoundary(fn,aver,'clean','skel');

%% Get Background Mask

bgMask = backgroundMask(f1);
% returns a logical map or areas in the background, i.e. not cell (or too near cell)
% or anyother bright spots.

%% getting intensity plots
% Generating intensity plots can be done as in the below example for the background

%% Plot area
I = zeros(l,1);
for k =1:l
    I(k) = sum(sum(f1(k).image.*bgMask)); % Finds intensity in backgroung per frame
end
 
plot(1:l, (I)/(sum(sum(bgMask))));% divides by background area
