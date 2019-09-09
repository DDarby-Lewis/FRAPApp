function [footage, fData] = getFootage(file, varargin)
% getFootage takes a file and returns the footage
% Created by Daniel Darby, adapted from extract_image_sequence_data.m by
% Isabel Llorente Garcia.
% Reads image sequence of tybe .sif, .dv, .tif, .mat data or .mv2d and 
% returns image data in a useful form (a structure)
%
% Inputs: 
% file: file, including .type and full path input file contains the footage
% on a sutiable file format
% 
% varargin{1} = desired data series (optional, defults to one)
% 
% 
% Outputs:
% footage: complete set of images from file in a 3D array
% fData, structure containing fields:
%   'numFrames': number of frames in footage for series.
%   'Ysize': vertical (first dimension of matrix) size of image in pixels
%   for series.
%   'Xsize': horizontal (second dimension of matrix) size of image in
%   pixels for series.
%   'ColData': Collection Data, including camera/decetor model & make,
%   pixel length etc
%   
%   
% Usage:
% [f1, dF1] = getFootage('N:\FRAP\Data\FRAP_data\filename.mvd2');
% this will automatically open the first series of data, to open series n:
% [fn, dFn] = getFootage('N:\FRAP\Data\FRAP_data\filename.mvd2', n);
% where n is desired series number
% 

%% Initialising and Error control:
% Sets up initial variaibles and errors.

% Initial stuff necessary for labeling
if exist(file,'file')
    [~, ~, ext] = fileparts(file); %takes care of ID'ing the file type
else
    error('gFootage:file', 'File not found');
end

% For setting the series number
if nargin < 2
    seriesNum = 1; % No series number input provided assume series 1.
elseif nargin == 2 && isnumeric(varargin{1})
    seriesNum = varargin{1};
else
    error('gFootage:inarg', 'Too many input arguments or input 2 (desired series number) is not numeric');
end

% Contains supplimentary data
fData = struct('numFrames', {}, 'Ysize', {}, 'Xsize', {}, 'file', {},'ext', {}, 'seriesNum', {}, 'numSeries', {});
% fData(1).file = file;
fData(1).ext = ext;
fData(1).seriesNum = seriesNum;

numSeries = 1;

%% For .mvd2 files
% requires bfopen.m and loci_tools.jar

if strcmpi('.mvd2', ext)
    data = bfopen(file, seriesNum); % data is a cell array of cell arrays.
    numSeries = size(data,1);
    series = data{seriesNum,1}; 
    thisnumFrames = size(series,1); 

    % vectorised code
    footage = double(cat(3,series{:,1}));

    % Add other useful info to final output:
    fData(1).numFrames = thisnumFrames;
    fData(1).Ysize = size(footage,1);
    fData(1).Xsize = size(footage,2);
    fData(1).camera = data{1,2}; 

%% For .avi files

elseif strcmpi('.avi', ext)
    data = VideoReader(file);
    numSeries = 1;
    thisnumFrames = data.NumberOfFrames;

    footage=zeros(data.Width,data.Height,thisnumFrames); % creating a video 3d matrix

    for k = 1 : thisnumFrames
        im = sum(read(data,k),3);
        footage(:,:,k)= mat2gray(double(im));
    end

    % Add other useful info to final output:
    fData(1).numFrames = thisnumFrames;
    fData(1).Ysize = data.Height;
    fData(1).Xsize = data.Width;
%     fData(1).camera = data.VideoPare; 

    

%% For .dv files 
% This needs bfopen.m and loci_tools.jar (see folder bfmatlab):

elseif strcmpi('.dv', ext)

    data = bfopen(file); % data is a cell array of cell arrays.
    % Assumming there is only one series, i.e., that numSeries = size(data,1)=1, we do:
    series1 = data{1,1}; % this cell array contains an array where each row (first index, p) corresponds to a frame.
    % First column (series1{p,1}) is the matrix data for the image frame. Second column (series1{p,2}) is the
    % frame label with path and info.
    series1_numFrames = size(series1,1); % number of frames in the image sequence.
    % Each image frame matrix data is series1{p,1}, with real intensity numbers
    % (not between 0 and 1).
    
    % To produce image data in final output form:
    
    % Vectorised code
    footage = mat2gray(double(cat(3,series1{:,1})));
%     % Loop through frames:
%     for p = 1:series1_numFrames
%         frame = series1{p,1};
%         frame = double(frame);  % to class double.
%         frame = mat2gray(frame);
%         footage(p).image = frame; 
%         % image data needs to be of class double for future operations (for findSpotCentre1frame.m).
%     end
    
    % Add other useful info to final output:
    fData(1).numFrames = series1_numFrames;
    fData(1).Ysize = size(footage,1);
    fData(1).Xsize = size(footage,2);
    fData(1).camera = data{1,2};  


%% For .sif files:

elseif strcmpi('.sif', ext);
    
    
    % First get size of .sif image file: (see IO_Input folder, SifFunctions.txt, or page 95 my notebook 1).
    % See Isabel/myMatlabFiles/IO_input folder.
    [~, fData(1).numFrames, ImageSize, ~]=GetAndorSifSize(file,0);
    
    % numFrames is the length of the sequence, the number of frames.
    % ImageSize is the size of the image, e.g. 512*512 = 262144.
    % TotalAcquisitionSize is numFrames*ImageSize
    
    % read .sif image data. sifData is an array of 1x1 structures, as many
    % columns as frames on image sequence. Read frames 1 to numFrames:
    [sifData] = read_sif_data_direct(file,fData(1).numFrames,ImageSize,1,fData(1).numFrames); % sifData is a cell array.
    
    footage = mat2gray(double(cat(3,sifData{:}.sliceData)));
    
%     for p = 1: fData(1).numFrames
%         frame = sifData{p}.sliceData; % extract frame data which is stored in the field 'sliceData'.
%         frame = double(frame); % to class double.
%         frame = mat2gray(frame);
%         footage(p).image = imrotate(frame,90); % original intensity values (needs to be rotated).
%         % image data needs to be of class double for future operations (for
%         % findSpotCentre1frame.m).
%     end
%     
    % Get frame dimensions:
    fData(1).Ysize = size(footage,1);
    fData(1).Xsize = size(footage,2);
    

%% For .tif files 

elseif strcmpi('.tif', ext)
    

    tif_info = imfinfo(file);
    % Add other useful info to final output:
    numFrames = length(tif_info); % number of frames in sequence.
    Ysize = tif_info(1).Height;
    Xsize = tif_info(1).Width;
    % Make the image be a square image:
    Ysize = min(Ysize,Xsize);
    Xsize = min(Ysize,Xsize);
    % If the frame size is an odd number:
    if mod(Ysize,2)~=0 % modulus after division
        Ysize = Ysize - 1;
        Xsize = Xsize - 1;
    end
    
    % To produce image data in final output form:
    %vectorised
    footage = mat2gray(double(cat(3,imread(file,1:numFrames))));

%     % Loop through frames:
%     for p = 1: numFrames
%         % frame = imread(image_path,p); % read frame number p, read full image.
%         frame = imread(image_path,p,'PixelRegion', {[1,Ysize], [1,Xsize]}); % read only a part of image, to have a square image at the end.
%         frame = single(frame);  % to class single.
%         frame = double(frame);  % to class double.
%         frame = mat2gray(frame);
%         footage(p).image = frame; 
%         % image data needs to be of class double for future operations (for findSpotCentre1frame.m).
%     end
    
    fData(1).numFrames = numFrames;
    fData(1).Xsize = Xsize;
    fData(1).Ysize = Ysize;


%% For .mat files 

elseif strcmpi('.mat', ext)
    
    file = file;
    
    load(file); % load mat file.
    % The mat file should contain a matrix of size frameSizeY x frameSizeX
    % x numFrames.
    
    file_info = whos('-file',file);
    % this returns a structure with fields, eg.:
    %     name: 'A_image_sequence'
    %     size: [400 400 100]
    %     bytes: 128000000
    %     class: 'double'
    %     global: 0
    %     sparse: 0
    %     complex: 0
    %     nesting: [1x1 struct]
    %     persistent: 0
    
    % Get useful info for final output:
    numFrames = file_info.size(3); % number of frames in sequence.
    Ysize = file_info.size(1);
    Xsize = file_info.size(2);
    % Make the image be a square image:
    Ysize = min(Ysize,Xsize);
    Xsize = min(Ysize,Xsize);
    % If the frame size is an odd number:
    if mod(Ysize,2)~=0 % modulus after division
        Ysize = Ysize - 1;
        Xsize = Xsize - 1;
    end
        
    % To produce image data in final output form:
    image_sequence = eval(file_info.name); % evaluate the string containing the matrix name to get the matrix data into a variable.

    %vectorised
    footage = mat2gray(double(cat(3,image_sequence(:,:,:))));
    % Loop through frames:
%     for p = 1:numFrames
%         frame = image_sequence(:,:,p);
% %         frame = single(frame);  % to class single.
%         frame = double(frame);  % to class double.
%         frame = mat2gray(frame);
%         footage(p).image = frame; 
%         % image data needs to be of class double for future operations (for findSpotCentre1frame.m).
%     end
    
    fData(1).numFrames = numFrames;
    fData(1).Xsize = Xsize;
    fData(1).Ysize = Ysize;
    
else
    error('gFootage:ext', ['Cannot deal with file extention of type', ext]);
end

fData(1).numSeries = numSeries;


%% mat2gray each frame individually
for p = 1: fData(1).numFrames;
    footage(:,:,p) = mat2gray(footage(:,:,p));
end

%% Output info to command window:

disp(file) % write footage name to command window.
fprintf('There are a total of %i series in this data file \nThe total number of frames in this image sequence is: %i \n',fData(1).numSeries, fData(1).numFrames) %output total number of frames to command window.



%% Tests

%  % To show a video:
%  % Loop through frames:
% for p = 1:numFrames
%     imshow(image_data(p).image,[]);
%     pause(0.1);
% end


% -------------------
% Alternatively:
% uigetfile opens a file dialog box to choose data file:
% [file_data,path_data] = uigetfile({'*.sif'}, 'Chose image data sequence:');
% strcat('data (.sif image):','  ',path_data,file_data)
% open a file dialog box to choose analysis file:
% [file_analysis,path_analysis] = uigetfile({'*.xls'}, 'Chose analysis file (trajectory):');
% strcat('analysis file (.xls trajectory):','
% ',path_analysis,file_analysis)