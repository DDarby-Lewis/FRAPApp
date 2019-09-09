function varargout = guiFRAP(varargin)
% GUIFRAP MATLAB code for guiFRAP.fig
%      GUIFRAP, by itself, creates a new GUIFRAP or raises the existing
%      singleton*.
%
%      H = GUIFRAP returns the handle to a new GUIFRAP or the handle to
%      the existing singleton*.
%
%      GUIFRAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFRAP.M with the given input arguments.
%
%      GUIFRAP('Property','Value',...) creates a new GUIFRAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiFRAP_OpeningFcn gets called.  An
%      unRectognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiFRAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiFRAP

% Last Modified by GUIDE v2.5 25-Sep-2014 10:01:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFRAP_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFRAP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiFRAP is made visible.
function guiFRAP_OpeningFcn(hObject, eventdata, handles, varargin) 
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiFRAP (see VARARGIN)

% Initilise Variables
handles.seriesNum = 1;
handles.fpsFootage = 25;
handles.startFrame = 1;
handles.endFrame = 'end';
set(handles.end_Frame,'String','end')
handles.cellThresh = [];
handles.bleachThresh = [];
handles.bgThresh = [];
handles.initialFrames = [];
handles.postBleach = [];
handles.pixelWidth = 60;

axes(handles.show_Footage)
imshow(0);
im = getimage(handles.show_Footage);
if sum(sum(im)) == 0
    text(1,1 ,{'Footage', 'will be', 'Displayed', 'Here'},...
    'BackgroundColor', 'White','FontWeight','Bold','HorizontalAlignment','center','FontSize', 15)
end
%Removes the apperance of the progress playing bar
axes(handles.playing_Footage);axis off;

% Choose default command line output for guiFRAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiFRAP wait for user response (see UIRESUME)
% uiwait(handles.gui_FRAP);


% --- Outputs from this function are returned to the command line.
function varargout = guiFRAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in get_File.
function file = get_File_Callback(hObject, eventdata, handles)
% hObject    handle to get_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,filePath] = uigetfile('*');
currentFiles = cellstr(get(handles.select_File, 'String'));

if ischar(filePath) && ischar(fileName)
    currentFiles{end+1} = strcat(filePath,fileName);
    set(handles.select_File, 'String', currentFiles);
    set(handles.select_File, 'Value', length(currentFiles));
    handles.file = strcat(filePath,fileName);
    file = handles.file;
    set(handles.select_File,'BackgroundColor','white');
else
    file = [];
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function select_File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in select_File.
function select_File_Callback(hObject, eventdata, handles)
% hObject    handle to select_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_File contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_File
set(hObject,'BackgroundColor','white');
fileString = cellstr(get(hObject,'String'));
handles.file = fileString{get(hObject,'Value')};
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function series_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to series_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on text change in series_Num.
function series_Num_Callback(hObject, eventdata, handles)
% hObject    handle to series_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of series_Num as text
%        str2double(get(hObject,'String')) returns contents of series_Num as a double

set(hObject,'BackgroundColor','White'); %Return to white after error
handles.seriesNum = str2double(get(hObject,'String'));%Return string as number or NAN

if ~isreal(handles.seriesNum)|| ~isnumeric(handles.seriesNum) || isnan(handles.seriesNum)||...
        isempty(handles.seriesNum)|| ~(ceil(handles.seriesNum) == floor(handles.seriesNum)) || ~(handles.seriesNum > 0)
    set(handles.series_Num,'BackgroundColor',[1,0,0]);
end
% Update handles structure
guidata(hObject, handles);
% --- Executes on key press with focus on series_Num and none of its controls.
function series_Num_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to series_Num (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.series_Num,'BackgroundColor','White');
if strcmp(eventdata.Key, 'return')
    drawnow
    set(handles.series_Num,'Value',str2double(get(handles.series_Num,'String')));
    handles.seriesNum = str2double(get(handles.series_Num,'String'));
    load_Series_Callback(handles.load_Series, eventdata, handles);
end


% --- Executes on button press in load_Series.
function load_Series_Callback(hObject, eventdata, handles)
% hObject    handle to load_Series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.load_Series,'ForegroundColor','Black');
try
    currentFiles = cellstr(get(handles.select_File, 'String'));

    if strcmp(currentFiles{get(handles.select_File,'Value')}, 'Select File')|| isempty(currentFiles{get(handles.select_File,'Value')})
        file = get_File_Callback(hObject, eventdata, handles);
        handles.file = file;
    else
        file = currentFiles{get(handles.select_File,'Value')};
        handles.file = file;
    end
    if isempty(file)
        error('lSerC:noFile', 'Must Select File');
    end
    if ~isreal(handles.seriesNum)|| ~isnumeric(handles.seriesNum) || isnan(handles.seriesNum)||...
        isempty(handles.seriesNum)||~isinteger(handles.seriesNum) && ~handles.seriesNum>0
        error('lSerC:num','Series Number Invalid');
    end
    
    % generate footage
    set(handles.load_File_Progress,'String', 'Loading...');
    ticFile = tic;
    drawnow
    [footage,fData] = getFootage(handles.file, handles.seriesNum);
    set(handles.total_Series,'String',['Total series: ',num2str(fData.numSeries)]);
    
    % generate the title for footage series
    [~, fileName] = fileparts(handles.file);
    seriesLabel = strrep(strcat('file_',fileName, '_Series', num2str(handles.seriesNum)),' ', '');
    currentFootage = cellstr(get(handles.select_Footage, 'String'));
    if any(strcmp(fieldnames(handles),'seriesLabelCount'))&&...
            any(strcmp(fieldnames(handles.seriesLabelCount),seriesLabel));
        handles.seriesLabelCount.(seriesLabel) = handles.seriesLabelCount.(seriesLabel) + 1;
        seriesLabel = strcat(seriesLabel,'_',num2str(handles.seriesLabelCount.(seriesLabel)));
    else
        handles.seriesLabelCount.(seriesLabel) = 0;
    end
    
    if isempty(get(handles.select_Footage, 'String'))
        currentFootage = {seriesLabel};
    else
        currentFootage{end+1} = seriesLabel;
    end
   
    % put data into handles
    handles.footage.(seriesLabel) = footage;
    handles.fData.(seriesLabel) = fData;
    
    
    % set the title for footage series select
    set(handles.select_Footage, 'String', currentFootage);
    set(handles.select_Footage, 'Value', length(currentFootage));
    
    handles.selectedFootage = currentFootage{get(handles.select_Footage,'Value')};
    
    % show first image as a preview
    axes(handles.show_Footage);
    imshow(handles.footage.(handles.selectedFootage)(:,:,1));
    
    select_Footage_Callback(handles.select_Footage, eventdata, handles);
    
    handles.endFrame = size(handles.footage.(handles.selectedFootage), 3);
    handles.xStart = 1;
    handles.yStart = 1;
    handles.width = size(handles.footage.(handles.selectedFootage),1);
    handles.height = size(handles.footage.(handles.selectedFootage),2);
    
    if ndims(handles.footage.(seriesLabel)) == 3
        set(handles.load_File_Progress,'String', ['Done in ',num2str(toc(ticFile)),' seconds']);
    else
        set(handles.load_File_Progress,'String', 'Failed');
    end
    
    % Update handles structure
    guidata(hObject, handles);
catch err
    switch err.identifier
        case 'gFootage:ext'
            set(handles.load_File_Progress,'String', 'Failed: File Extention Not Recognised');
            set(handles.select_File,'BackgroundColor',[1,0,0]);
        case 'gFootage:file'
            set(handles.load_File_Progress,'String', 'Failed: File Not Found');
            set(handles.select_File,'BackgroundColor',[1,0,0]);
        case 'lSerC:num'
            set(handles.load_File_Progress,'String', 'Series Number Invalid');
            set(handles.series_Num,'BackgroundColor',[1,0,0]);
        case 'lSerC:noFile'
            set(handles.load_File_Progress,'String', 'Must Select File');
            set(handles.select_File,'BackgroundColor',[1,0,0]);
        otherwise
            set(handles.load_File_Progress,'String', 'Failed');
            throw(err)
    end
    
end



% --- Executes during object creation, after setting all properties.
function select_Footage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in select_Footage.
function select_Footage_Callback(hObject, eventdata, handles)
% hObject    handle to select_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns select_Footage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_Footage
set(hObject,'BackgroundColor','white');
currentFootage = cellstr(get(hObject,'String'));
if length(currentFootage) ~= 1

    handles.selectedFootage = currentFootage{get(hObject,'Value')};
    % show first image as a preview
    axes(handles.show_Footage);
    imshow(handles.footage.(handles.selectedFootage)(:,:,1));

    %re initilise variables
    handles.startFrame = 1;
    handles.endFrame = size(handles.footage.(handles.selectedFootage), 3);
    handles.xStart = 1;
    handles.yStart = 1;
    handles.width = size(handles.footage.(handles.selectedFootage),1);
    handles.height = size(handles.footage.(handles.selectedFootage),2);
    set(handles.start_Frame,'String',handles.startFrame);
    set(handles.end_Frame,'String',handles.endFrame);
    set(handles.x_Start,'String',handles.xStart);
    set(handles.y_Start,'String',handles.yStart);
    set(handles.x_Width,'String',handles.width);
    set(handles.y_Height,'String',handles.height);
else
    set(hObject,'Value',1);
end
% Update handles structure
guidata(hObject, handles);
% --- Executes on key press with focus on select_Footage and none of its controls.
function select_Footage_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to select_Footage (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
ser = get(handles.select_Footage,'String');
if strcmp(eventdata.Key, 'delete')&&~isempty(ser)
    sel = handles.selectedFootage;
    ser(get(handles.select_Footage,'Value'))=[];        
    set(handles.select_Footage,'Value',length(ser));
    set(handles.select_Footage,'String',ser);
    if any(strcmp(fieldnames(handles),'footage'))&&any(strcmp(fieldnames(handles.footage),sel))
        handles.footage=rmfield(handles.footage,sel);
        if any(strcmp(fieldnames(handles),'cellMask'))&&any(strcmp(fieldnames(handles.cellMask),sel))
            handles.cellMask = rmfield(handles.cellMask,sel);
            if any(strcmp(fieldnames(handles),'bleachMask'))&&any(strcmp(fieldnames(handles.bleachMask),sel))
                handles.bleachMask=rmfield(handles.bleachMask,sel);
                if any(strcmp(fieldnames(handles),'bleachInstant'))&&any(strcmp(fieldnames(handles.bleachInstant),sel))
                    handles.bleachInstant=rmfield(handles.bleachMask,sel);
                end
                if any(strcmp(fieldnames(handles),'bgMask'))&&any(strcmp(fieldnames(handles.bgMask),sel))
                    handles.bgMask=rmfield(handles.bgMask,sel);
                    if any(strcmp(fieldnames(handles),'bgMask'))&&any(strcmp(fieldnames(handles.bgMask),sel))
                        handles.bgMask=rmfield(handles.bgMask,sel);
                    end
                end
                
            end
        end
    end
end
guidata(hObject,handles);


% --- Executes on button press in play_Footage.
function play_Footage_Callback(hObject, eventdata, handles)
% hObject    handle to play_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try % For catching errors controlled in the catch
    if ~strcmp(get(handles.playing_Progress,'String'),'Playing...') %if playing is allowed

        set(handles.playing_Progress,'String', 'Playing...');
        % Play all, odd or even footage.
        if get(handles.frames_All,'Value') == 1 %plays all
            playVid(handles.footage.(handles.selectedFootage),...
                [handles.startFrame,handles.endFrame],[],...
                handles.fpsFootage,handles.show_Footage,handles.playing_Footage)
        elseif get(handles.frames_Odd,'Value') == 1 %plays all
            playVid(handles.footage.(handles.selectedFootage),...
                [handles.startFrame,handles.endFrame],'odd',...
                handles.fpsFootage,handles.show_Footage,handles.playing_Footage)
        elseif get(handles.frames_Even,'Value') == 1 %plays all
            playVid(handles.footage.(handles.selectedFootage),...
                [handles.startFrame,handles.endFrame],'even',...
                handles.fpsFootage,handles.show_Footage,handles.playing_Footage)
        end
        set(handles.playing_Progress,'String', '...Finished');
        set(handles.play_Footage,'String', 'Play')
     end

        % Update handles structure
        guidata(hObject, handles);
catch err
    switch err.identifier
        case 'MATLAB:hg:dt_conv:Matrix_to_HObject:BadHandle'
        case 'MATLAB:nonExistentField'
            set(handles.select_Footage,'BackgroundColor', [1,0.9,0.9])
            set(handles.playing_Progress,'String', 'Select Footage')
        otherwise
            set(handles.playing_Progress,'String', 'Failed');
            throw(err);
    end
end


% --- Executes on button press in play_Stop.
function play_Stop_Callback(hObject, eventdata, handles)
% hObject    handle to play_Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.playing_Progress,'String'),'Playing...')
    axesDeleted = copyobj(handles.playing_Footage,get(handles.playing_Footage,'Parent'));
    delete(handles.playing_Footage);
    set(handles.playing_Progress,'String', 'Stopped');
    handles.playing_Footage = axesDeleted;
    guidata(hObject, handles);
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fps_Footage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fps_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fps_Footage_Callback(hObject, eventdata, handles)
% hObject    handle to fps_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fps_Footage as text
%        str2double(get(hObject,'String')) returns contents of fps_Footage as a double
set(handles.fps_Footage,'BackgroundColor','White');
handles.fpsFootage = str2double(get(hObject,'String'));
if isnan(handles.fpsFootage)
    set(hObject,'BackgroundColor',[1,0,0])
end

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function start_Frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function start_Frame_Callback(hObject, eventdata, handles)
% hObject    handle to start_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_Frame as text
%        str2double(get(hObject,'String')) returns contents of start_Frame as a double
set(handles.start_Frame,'BackgroundColor','White');
handles.startFrame = str2double(get(hObject,'String'));
if isnan(handles.startFrame)
    set(hObject,'BackgroundColor',[1,0,0])
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function end_Frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on key press with focus on end_Frame and none of its controls.
function end_Frame_Callback(hObject, eventdata, handles)
% hObject    handle to end_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_Frame as text
%        str2double(get(hObject,'String')) returns contents of end_Frame as a double
set(handles.end_Frame,'BackgroundColor','White');
if strcmp(get(handles.end_Frame,'String'),'end')
    handles.endFrame = size(handles.footage.(handles.selectedFootage), 3);
else
    handles.endFrame = str2double(get(hObject,'String'));
    if isnan(handles.endFrame)
        set(hObject,'BackgroundColor',[1,0,0])
    end
end

% Update handles structure
guidata(hObject, handles);


function x_Start_Callback(hObject, eventdata, handles)
% hObject    handle to x_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_Start as text
%        str2double(get(hObject,'String')) returns contents of x_Start as a double
set(handles.x_Start,'BackgroundColor','White');
handles.xStart = str2double(get(hObject,'String'));
if isnan(handles.xStart)
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function x_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function y_Start_Callback(hObject, eventdata, handles)
% hObject    handle to y_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_Start as text
%        str2double(get(hObject,'String')) returns contents of y_Start as a double
set(handles.y_Start,'BackgroundColor','White');
handles.yStart = str2double(get(hObject,'String'));
if isnan(handles.yStart)
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function y_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function x_Width_Callback(hObject, eventdata, handles)
% hObject    handle to x_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_Width as text
%        str2double(get(hObject,'String')) returns contents of x_Width as a double
set(handles.x_Width,'BackgroundColor','White');
handles.width = str2double(get(hObject,'String'));
if isnan(handles.width)
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function x_Width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function y_Height_Callback(hObject, eventdata, handles)
% hObject    handle to y_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_Height as text
%        str2double(get(hObject,'String')) returns contents of y_Height as a double
set(handles.y_Height,'BackgroundColor','White');
handles.height = str2double(get(hObject,'String'));
if isnan(handles.height)
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function y_Height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in crop_Tool.
function crop_Tool_Callback(hObject, eventdata, handles)
% hObject    handle to crop_Tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,ret] = imcrop(handles.show_Footage);
handles.xStart = round(ret(1));
handles.yStart = round(ret(2));
handles.width = round(ret(3));
handles.height = round(ret(4));
set(handles.x_Start,'String',handles.xStart);
set(handles.y_Start,'String',handles.yStart);
set(handles.x_Width,'String',handles.width);
set(handles.y_Height,'String',handles.height);
guidata(hObject,handles)


% --- Executes on button press in correct_Footage.
function correct_Footage_Callback(hObject, eventdata, handles)
% hObject    handle to correct_Footage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try % For catching errors controlled in the catch
    set(handles.playing_Progress,'String', 'Correcting...')
    drawnow
    if strcmp(handles.endFrame,'end')
        set(handles.end_Frame,'Value',size(handles.footage.(handles.selectedFootage), 3));
        handles.endFrame = size(handles.footage.(handles.selectedFootage), 3);
    end
    if get(handles.frames_All,'Value') == 1
        correctFootage = correctedFootage(handles.footage.(handles.selectedFootage),[handles.startFrame,handles.endFrame],[handles.xStart,handles.yStart,handles.width,handles.height]);
    elseif get(handles.frames_Odd,'Value') == 1 
        correctFootage = correctedFootage(handles.footage.(handles.selectedFootage),[handles.startFrame,handles.endFrame],[handles.xStart,handles.yStart,handles.width,handles.height],'odd');
    elseif get(handles.frames_Even,'Value') == 1 
        correctFootage = correctedFootage(handles.footage.(handles.selectedFootage),[handles.startFrame,handles.endFrame],[handles.xStart,handles.yStart,handles.width,handles.height],'even');
    end

    % generate name
    split1 = strsplit(handles.selectedFootage,'_');
    seriesLabel = cell2mat(strcat(split1(1),'_',split1(2),'_',split1(3)));
    currentFootage = cellstr(get(handles.select_Footage, 'String'));
    if any(strcmp(fieldnames(handles),'seriesLabelCount'))&&...
            any(strcmp(fieldnames(handles.seriesLabelCount),seriesLabel));
        handles.seriesLabelCount.(seriesLabel) = handles.seriesLabelCount.(seriesLabel) + 1;
        seriesLabel = strcat(seriesLabel,'_',num2str(handles.seriesLabelCount.(seriesLabel)));
    else
        handles.seriesLabelCount.(seriesLabel) = 0;
    end
    
    currentFootage{end+1} = seriesLabel;
    handles.footage.(seriesLabel) = correctFootage;

    % set the title for footage series select
    set(handles.select_Footage, 'String', currentFootage);
    set(handles.select_Footage, 'Value', length(currentFootage));
    handles.selectedFootage = currentFootage{get(handles.select_Footage,'Value')};
    select_Footage_Callback(handles.select_Footage, eventdata, handles);
    set(handles.playing_Progress,'String', 'Done')
    guidata(hObject,handles);
catch err
    switch err.identifier
        case 'MATLAB:nonExistentField'
            set(handles.select_Footage,'BackgroundColor', [1,0.9,0.9])
            set(handles.playing_Progress,'String', 'Select Footage')
        otherwise
            set(handles.playing_Progress,'String', 'Failed')
            throw(err)
    end
    
end

% --- Executes on button press in reset_Play_Options.
function reset_Play_Options_Callback(hObject, eventdata, handles)
% hObject    handle to reset_Play_Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.frames_All,'Value',1);
set(handles.fps_Footage,'String',25);
set(handles.start_Frame,'String',1);
set(handles.end_Frame,'String',size(handles.footage.(handles.selectedFootage),3));
set(handles.x_Start,'String',1);
set(handles.y_Start,'String',1);
set(handles.x_Width,'String',size(handles.footage.(handles.selectedFootage),1));
set(handles.y_Height,'String',size(handles.footage.(handles.selectedFootage),2));
axes(handles.show_Footage)
imshow(handles.footage.(handles.selectedFootage)(:,:,1));
guidata(hObject,handles);



% --- Executes on button press in get_Cell_Mask.
function get_Cell_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to get_Cell_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.get_Cell_Mask,'ForegroundColor',[0,0,0]);
if any(strcmp(fieldnames(handles),'selectedFootage'))&& ~strcmp('Busy...',get(handles.get_Cell_Mask,'String'))
    set(handles.get_Cell_Mask,'String','Busy...');drawnow

    if get(handles.cs_C,'Value') == 1 && get(handles.cs_S,'Value') == 1
        [handles.cellMask.(handles.selectedFootage),handles.cellBoundary.(handles.selectedFootage) ] = ...
            cellMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellThresh,handles.initialFrames,'no','clean','skel');
    elseif get(handles.cs_C,'Value') == 1
        [handles.cellMask.(handles.selectedFootage),handles.cellBoundary.(handles.selectedFootage) ] = ...
            cellMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellThresh,handles.initialFrames,'no','clean');
    elseif get(handles.cs_S,'Value') == 1
        [handles.cellMask.(handles.selectedFootage),handles.cellBoundary.(handles.selectedFootage) ] = ...
            cellMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellThresh,handles.initialFrames,'no','skel');
    else
        [handles.cellMask.(handles.selectedFootage),handles.cellBoundary.(handles.selectedFootage) ] = ...
            cellMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellThresh,handles.initialFrames,'no');
    end  
    boundary(:,:,1) = handles.cellBoundary.(handles.selectedFootage);
    boundary(:,:,2:3) = 0;
    axes(handles.show_Footage)
    imshow(boundary+repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[])
    title('Cell Mask Boundary on First Frame');
    guidata(hObject,handles);
elseif ~strcmp('Busy...',get(handles.get_Cell_Mask,'String'))
    set(handles.load_Series,'ForegroundColor',[1,0,0])
end
set(handles.get_Cell_Mask,'String','Cell Mask');


% --- Executes during object creation, after setting all properties.
function cell_Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cell_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to cell_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_Threshold as text
%        str2double(get(hObject,'String')) returns contents of cell_Threshold as a double
handles.cellThresh = str2double(get(handles.cell_Threshold,'String'));
if strcmp(get(handles.cell_Threshold,'String'),'auto')
    handles.cellThresh = [];
elseif isnan(handles.cellThresh)||handles.cellThresh>1||handles.cellThresh<0
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);



% --- Executes on button press in get_Bleach_Mask.
function get_Bleach_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to get_Bleach_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.get_Bleach_Mask,'ForegroundColor','Black');
if any(strcmp(fieldnames(handles),'cellMask'))&& any(strcmp(...
        fieldnames(handles.cellMask),handles.selectedFootage))&& ~strcmp(...
        'Busy...',get(handles.get_Bleach_Mask,'String'))
    set(handles.get_Bleach_Mask,'String','Busy...');drawnow
    
    if get(handles.cs_C,'Value') == 1 && get(handles.cs_S,'Value') == 1
        [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage),handles.bleachInstant.(handles.selectedFootage) ] = ...
        bleachMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellMask.(handles.selectedFootage),handles.bleachThresh,'no','clean','skel');
    elseif get(handles.cs_C,'Value') == 1
        [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage),handles.bleachInstant.(handles.selectedFootage) ] = ...
        bleachMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellMask.(handles.selectedFootage),handles.bleachThresh,'no','clean');
    elseif get(handles.cs_S,'Value') == 1
        [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage),handles.bleachInstant.(handles.selectedFootage) ] = ...
        bleachMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellMask.(handles.selectedFootage),handles.bleachThresh,'no','skel');
    else
        [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage),handles.bleachInstant.(handles.selectedFootage) ] = ...
        bleachMaskAndBoundary(handles.footage.(handles.selectedFootage),handles.cellMask.(handles.selectedFootage),handles.bleachThresh,'no');
    end 
    
    axes(handles.show_Footage)
    cboundary(:,:,1) = handles.cellBoundary.(handles.selectedFootage);
    cboundary(:,:,2:3) = 0;
    boundary(:,:,2) = handles.bleachBoundary.(handles.selectedFootage);
    boundary(:,:,1) = 0;boundary(:,:,3) = 0;
    if get(handles.bleach_Instant_Check,'Value') == 1
        imshow(cboundary+boundary + repmat(handles.footage.(handles.selectedFootage)(:,:,handles.bleachInstant.(handles.selectedFootage)),[1,1,3]),[]);
        title({'Cell and Bleach Mask Boundaries'; ['on First Post Bleach Frame: ',num2str(handles.bleachInstant.(handles.selectedFootage))]});
    else
        imshow(cboundary+boundary + repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[]);
        title({'Cell and Bleach Mask Boundaries'; 'on First Frame'});
    end
    guidata(hObject,handles);
elseif ~strcmp('Busy...',get(handles.get_Bleach_Mask,'String'))
    set(handles.get_Cell_Mask,'ForegroundColor',[1,0,0]);
end
set(handles.get_Bleach_Mask,'String','Bleach Mask');


% --- Executes during object creation, after setting all properties.
function bleach_Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bleach_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bleach_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to bleach_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bleach_Threshold as text
%        str2double(get(hObject,'String')) returns contents of bleach_Threshold as a double
set(hObject,'BackgroundColor','White')
handles.bleachThresh = str2double(get(handles.bleach_Threshold,'String'));
if strcmp(get(handles.bleach_Threshold,'String'),'auto')
    handles.bleachThresh = [];
elseif isnan(handles.bleachThresh)||handles.bleachThresh>1||handles.bleachThresh<0
    set(hObject,'BackgroundColor',[1,0,0])
end
guidata(hObject,handles);



% --- Executes on button press in manual_Mask.
function manual_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to manual_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.out = dialog('WindowStyle','normal','Name', 'Manual Bleach Mask','position',[400,400,250,100]);
% 
% circ = uicontrol(handles.out,'style','pushbutton', 'units','normalized','string','Circular Bleach Mask','position',[0,0,.5,.5]);
% set(circ,'Callback',@circle_Callback);
% ret = uicontrol(handles.out,'style','pushbutton', 'units','normalized','string','Retangular Bleach Mask','position',[0,.5,.5,.5]);

set(handles.manual_Mask,'ForegroundColor','Black');
if any(strcmp(fieldnames(handles),'cellMask'))&& any(strcmp(...
        fieldnames(handles.cellMask),handles.selectedFootage))
    set(handles.manual_Mask,'String','Busy...');
    % Construct a questdlg with three options
    out = questdlg('Select a Mask Shape', ...
        'Manual Bleach Mask', ...
        'Circular Bleach Mask','Retangular Bleach Mask','Cancel','Cancel');      
    axes(handles.show_Footage);
    % Handle response
    handles.rectWidth.(handles.selectedFootage) = 0;
    switch out
        case 'Circular Bleach Mask'
            w = str2double(inputdlg('Radius of Circle (Pixels): '));

            [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage)] = manualMask('circular', w, handles.footage.(handles.selectedFootage)(:,:,1));
            
        case 'Retangular Bleach Mask'
            w = str2double(inputdlg({'Width of Rectangle (Pixels): ','Height of Rectangle (Pixels): ','Rotation of Rectangle (Pixels): '}));
            [handles.bleachMask.(handles.selectedFootage),handles.bleachBoundary.(handles.selectedFootage)] = manualMask('rectangular', w, handles.footage.(handles.selectedFootage)(:,:,1));
            if w(1) < w(2)
                handles.rectWidth.(handles.selectedFootage) = w(1);
            else
                handles.rectWidth.(handles.selectedFootage) = w(2);
            end
    
    end
elseif ~strcmp('Busy...',get(handles.get_Bleach_Mask,'String'))
    set(handles.get_Cell_Mask,'ForegroundColor',[1,0,0]);
end

boundary(:,:,2) = handles.bleachBoundary.(handles.selectedFootage);
boundary(:,:,1) = 0;boundary(:,:,3) = 0;
cboundary(:,:,1) = handles.cellBoundary.(handles.selectedFootage);
cboundary(:,:,2:3) = 0;
imshow(boundary + cboundary + repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]));

set(handles.manual_Mask,'String','Mask');
guidata(hObject,handles);


% --- Executes on button press in manual_Instant.
function manual_Instant_Callback(hObject, eventdata, handles)
% hObject    handle to manual_Instant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if any(strcmp(fieldnames(handles),'selectedFootage'))
    handles.bleachInstant.(handles.selectedFootage) = str2double(inputdlg('Bleach Instant Frame number: '));
end
guidata(hObject,handles);

% --- Executes on button press in get_Bg_Mask.
function get_Bg_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to get_Bg_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.get_Bg_Mask,'ForegroundColor','black');
if any(strcmp(fieldnames(handles),'bleachMask'))&& any(strcmp(...
        fieldnames(handles.bleachMask),handles.selectedFootage))&& ~strcmp(...
        'Busy...',get(handles.get_Bg_Mask,'String'))
    set(handles.get_Bg_Mask,'String','Busy...');drawnow
    
    handles.bgMask.(handles.selectedFootage)= backgroundMask(handles.footage.(handles.selectedFootage),handles.bgThresh);
    
    axes(handles.show_Footage)
    cboundary(:,:,1) = handles.cellBoundary.(handles.selectedFootage);
    cboundary(:,:,2:3) = 0;
    boundary(:,:,2) = handles.bleachBoundary.(handles.selectedFootage);
    boundary(:,:,1) = 0;boundary(:,:,3) = 0;
    mask(:,:,3) = handles.bgMask.(handles.selectedFootage);
    mask(:,:,1:2) = 0;
    if get(handles.bleach_Instant_Check,'Value') == 1
        imshow(mask/2+cboundary+boundary + repmat(handles.footage.(handles.selectedFootage)(:,:,handles.bleachInstant.(handles.selectedFootage)),[1,1,3]),[]);
        title({'Cell and Bleach Mask Boundaries with'; ['Background Mask on First Post Bleach Frame: ',num2str(handles.bleachInstant.(handles.selectedFootage))]});
    else
        imshow(mask/2+cboundary+boundary + repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[]);
        title({'Cell and Bleach Mask Boundaries with'; 'Background Mask on First Frame'});
    end
    guidata(hObject,handles);
elseif ~strcmp('Busy...',get(handles.get_Bg_Mask,'String'))
    set(handles.get_Bleach_Mask,'ForegroundColor',[1,0,0]);
end
set(handles.get_Bg_Mask,'String','Background');




function bg_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to bg_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_Threshold as text
%        str2double(get(hObject,'String')) returns contents of bg_Threshold as a double
set(hObject,'BackgroundColor','White')
handles.bgThresh = str2double(get(handles.bg_Threshold,'String'));
if strcmp(get(handles.bg_Threshold,'String'),'auto')
    handles.bgThresh = [];
elseif isnan(handles.bgThresh)||handles.bgThresh>1||handles.bgThresh<0
    set(hObject,'BackgroundColor',[1,0,0])
    handles.bgThresh = [];
end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function bg_Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function post_Bleach_Callback(hObject, eventdata, handles)
% hObject    handle to post_Bleach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of post_Bleach as text
%        str2double(get(hObject,'String')) returns contents of post_Bleach as a double
set(hObject,'BackgroundColor','White')
handles.postBleach = str2double(get(handles.post_Bleach,'String'));
if strcmp(get(handles.post_Bleach,'String'),'auto')
    handles.postBleach = [];
elseif isnan(handles.postBleach)
    set(hObject,'BackgroundColor',[1,0,0])
    handles.postBleach = [];
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function post_Bleach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to post_Bleach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in view_Masks.
function view_Masks_Callback(hObject, eventdata, handles)
% hObject    handle to view_Masks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.show_Footage)
if any(strcmp(fieldnames(handles),'cellMask'))&& any(strcmp(...
        fieldnames(handles.cellMask),handles.selectedFootage))
    cboundary(:,:,1) = handles.cellBoundary.(handles.selectedFootage);
    cboundary(:,:,2:3) = 0;
    if any(strcmp(fieldnames(handles),'bleachMask'))&& any(strcmp(...
            fieldnames(handles.bleachMask),handles.selectedFootage))
        bboundary(:,:,2) = handles.bleachBoundary.(handles.selectedFootage);
        bboundary(:,:,1) = 0;bboundary(:,:,3) = 0;
        if any(strcmp(fieldnames(handles),'bgMask'))&& any(strcmp(...
                fieldnames(handles.bgMask),handles.selectedFootage))
            bgmask(:,:,3) = handles.bgMask.(handles.selectedFootage);
            bgmask(:,:,1:2) = 0;
            if get(handles.bleach_Instant_Check,'Value') == 1
                imshow(bgmask/2+cboundary+bboundary + repmat(handles.footage.(handles.selectedFootage)(:,:,handles.bleachInstant.(handles.selectedFootage)),[1,1,3]),[]);
                title({'Cell and Bleach Mask Boundaries with'; ['Background Mask on First Post Bleach Frame: ',num2str(handles.bleachInstant.(handles.selectedFootage))]});
            else
                imshow(bgmask/2+cboundary+bboundary + repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[]);
                title({'Cell and Bleach Mask Boundaries with'; 'Background Mask on First Frame'});
            end
        else
            if get(handles.bleach_Instant_Check,'Value') == 1
                imshow(cboundary+bboundary + repmat(handles.footage.(handles.selectedFootage)(:,:,handles.bleachInstant.(handles.selectedFootage)),[1,1,3]),[]);
                title({'Cell and Bleach Mask Boundaries'; ['on First Post Bleach Frame: ',num2str(handles.bleachInstant.(handles.selectedFootage))]});
            else
                imshow(cboundary+bboundary + repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[]);
                title({'Cell and Bleach Mask Boundaries'; 'on First Frame'});
            end
        end
    else
        imshow(cboundary+ repmat(handles.footage.(handles.selectedFootage)(:,:,1),[1,1,3]),[]);
        title('Cell Mask Boundary on First Frame');
    end
else
    title({'NO MASKS FOUND','Showing First Frame'});
end

    


function inital_Frames_Callback(hObject, eventdata, handles)
% hObject    handle to inital_Frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inital_Frames as text
%        str2double(get(hObject,'String')) returns contents of inital_Frames as a double
set(hObject,'BackgroundColor','White')
handles.initialFrames = str2double(get(handles.inital_Frames,'String'));
if strcmp(get(handles.inital_Frames,'String'),'auto')
    handles.initialFrames = [];
elseif isnan(handles.initialFrames)
    set(hObject,'BackgroundColor',[1,0,0])
    handles.initialFrames = [];
end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function inital_Frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inital_Frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in settings_Fitting.
function settings_Fitting_Callback(hObject, eventdata, handles)
% hObject    handle to settings_Fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Average Post Bleach Frames: ';'Microns Per Pixel On Image';'Bleach Area Width (W)/pixels'};
settings = inputdlg(prompt,'Settings');

% --- Executes on button press in generate_Intensity.
function generate_Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to generate_Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.generate_Intensity,'ForegroundColor','black');
try
    set(handles.generate_Intensity,'String', 'Generating...');drawnow
    t = ((1:size(handles.footage.(handles.selectedFootage),3))-handles.bleachInstant.(handles.selectedFootage))*1/(handles.fpsFootage);
    % This is the time vector, 1/25 is the default footage frame rate [frames/s]
    handles.time.(handles.selectedFootage) = t;
    axes(handles.show_Footage)
%     get all intensities:
    [handles.rIb.(handles.selectedFootage),...
        handles.rIc.(handles.selectedFootage),...
        handles.rIbg.(handles.selectedFootage),...
        handles.dI.(handles.selectedFootage),...
        handles.fI.(handles.selectedFootage)] = ...
        intensityFRAP(handles.footage.(handles.selectedFootage),...
        handles.bleachMask.(handles.selectedFootage),...
        handles.bleachInstant.(handles.selectedFootage),...
        handles.cellMask.(handles.selectedFootage),...
        handles.bgMask.(handles.selectedFootage));
%     display Graphs:
    if get(handles.norm_R,'value')==1% raw
        % Raw
        plot(t,handles.rIb.(handles.selectedFootage), t,handles.rIc.(handles.selectedFootage), t,handles.rIbg.(handles.selectedFootage));
        title('Raw Intensity Curves')
        xlabel('Time Scale/s')
        ylabel('Raw Intensity per Pixel')
        axis([min(t),max(t),0,1])% Grid Axis
        grid on
        set(handles.show_Footage, 'GridLineStyle', '-');
        grid(handles.show_Footage,'minor')

        legend(handles.show_Footage, 'FRAP ROI Raw Intensities','Whole Cell Raw Intensity','Background Raw Intensity', 'Location', 'best' );

    elseif get(handles.norm_D,'value')==1% double norm
        %plot Double
        plot(t,handles.dI.(handles.selectedFootage))
        title('Double Normalised Curve')
        xlabel('Time Scale/s')
        ylabel('Normalised Intensity')

        axis([min(t),max(t),0,max(handles.dI.(handles.selectedFootage))])% Grid Axis
        grid on
        set(gca, 'GridLineStyle', '-');
        grid(gca,'minor')
        legend(handles.show_Footage, 'FRAP ROI Double Normalised Intensity', 'Location', 'best' );

    else% full norm
        % plot Full
        plot(t,handles.fI.(handles.selectedFootage))
        title('Full Normalised Curve')
        xlabel('Time Scale/s')
        ylabel('Normalised Intensity')

        axis([min(t),max(t),0,max(handles.fI.(handles.selectedFootage))])% Grid Axis
        grid on
        set(gca, 'GridLineStyle', '-');
        grid(gca,'minor')
        legend(handles.show_Footage, 'FRAP ROI Full Normalised Intensity', 'Location', 'best' );

    end
    drawnow
    guidata(hObject,handles)
    set(handles.generate_Intensity,'String', 'Generate Intentities');
catch err
    set(handles.generate_Intensity,'String', 'Failed');
    switch err.identifier
        case 'MATLAB:nonExistentField' 
            if ~any(strcmp(fieldnames(handles),'cellMask')) || ~any(strcmp(fieldnames(handles.cellMask),handles.selectedFootage))
                set(handles.get_Cell_Mask,'ForegroundColor',[1,0,0]);
            elseif ~any(strcmp(fieldnames(handles),'bleachMask')) || ~any(strcmp(fieldnames(handles.bleachMask),handles.selectedFootage))
                set(handles.get_Bleach_Mask,'ForegroundColor',[1,0,0]);
            elseif ~any(strcmp(fieldnames(handles),'bgMask')) || ~any(strcmp(fieldnames(handles.bgMask),handles.selectedFootage))
                set(handles.get_Bg_Mask,'ForegroundColor',[1,0,0]);
            else
                throw(err)
            end
            
        otherwise
            throw(err)
    end
end
    
% --- Executes when selected object is changed in analyse_Panel.
function analyse_Panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in analyse_Panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
% try
    t = ((1:size(handles.footage.(handles.selectedFootage),3))-handles.bleachInstant.(handles.selectedFootage))*1/(handles.fpsFootage);
    axes(handles.show_Footage)
    if hObject == handles.norm_R && any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
        % Raw
        plot(t,handles.rIb.(handles.selectedFootage), t,handles.rIc.(handles.selectedFootage), t,handles.rIbg.(handles.selectedFootage));
        title('Raw Intensity Curves')
        xlabel('Time Scale/s')
        ylabel('Raw Intensity per Pixel')
        axis([min(t),max(t),0,1])% Grid Axis
        grid on
        set(handles.show_Footage, 'GridLineStyle', '-');
        grid(handles.show_Footage,'minor')

        legend(handles.show_Footage, 'FRAP ROI Raw Intensities','Whole Cell Raw Intensity','Background Raw Intensity', 'Location', 'best' );
    elseif hObject == handles.norm_D && any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
        %Double
        plot(t,handles.dI.(handles.selectedFootage))
        title('Double Normalised Curve')
        xlabel('Time Scale/s')
        ylabel('Normalised Intensity')

        axis([min(t),max(t),0,max(handles.dI.(handles.selectedFootage))])% Grid Axis
        grid on
        set(gca, 'GridLineStyle', '-');
        grid(gca,'minor')
        legend(handles.show_Footage, 'FRAP ROI Double Normalised Intensity', 'Location', 'best' );

    elseif hObject == handles.norm_F && any(strcmp(fieldnames(handles),'fI')) && any(strcmp(fieldnames(handles.fI),handles.selectedFootage))
        % plot Full
        plot(t,handles.fI.(handles.selectedFootage))
        title('Full Normalised Curve')
        xlabel('Time Scale/s')
        ylabel('Normalised Intensity')
        
        axis([min(t),max(t),0,max(handles.fI.(handles.selectedFootage))])% Grid Axis
        grid on
        set(gca, 'GridLineStyle', '-');
        grid(gca,'minor')

        legend(handles.show_Footage, 'FRAP ROI Full Normalised Intensity', 'Location', 'best' );
    end
% catch err
%     throw(err)
% %     set(handles.get_Bleach_Mask,'ForegroundColor',[1,0,0]);
% end

% --- Executes on button press in fit_Kinetics.
function fit_Kinetics_Callback(hObject, eventdata, handles)
% hObject    handle to fit_Kinetics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.fit_Method,'String'));
strfit = contents{get(handles.fit_Method,'Value')};
set(hObject,'String','Fitting...');
set(hObject,'ForegroundColor','black');

switch strfit
    case 'Single Expoential'
        if get(handles.norm_R,'Value') == 1
            if any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
                
                [handles.srfitExp.(handles.selectedFootage), handles.srgoffitExp.(handles.selectedFootage), handles.srmobhalffitExp.(handles.selectedFootage), handles.sruncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.rIb.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_D,'Value') == 1 
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))

                [handles.sdfitExp.(handles.selectedFootage), handles.sdgoffitExp.(handles.selectedFootage), handles.sdmobhalffitExp.(handles.selectedFootage), handles.sduncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.dI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_F,'Value') == 1
            if any(strcmp(fieldnames(handles),'fI')) && any(strcmp(fieldnames(handles.fI),handles.selectedFootage))
                
                [handles.sffitExp.(handles.selectedFootage), handles.sfgoffitExp.(handles.selectedFootage), handles.sfmobhalffitExp.(handles.selectedFootage), handles.sfuncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.fI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        end 
    case 'Double Expoential'
        if get(handles.norm_R,'Value') == 1
            if any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
                
                [handles.drfitExp.(handles.selectedFootage), handles.drgoffitExp.(handles.selectedFootage), handles.drmobhalffitExp.(handles.selectedFootage), handles.druncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.rIb.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage),'double');
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_D,'Value') == 1 
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))

                [handles.ddfitExp.(handles.selectedFootage), handles.ddgoffitExp.(handles.selectedFootage), handles.ddmobhalffitExp.(handles.selectedFootage), handles.dduncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.dI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage),'double');
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_F,'Value') == 1
            if any(strcmp(fieldnames(handles),'fI')) && any(strcmp(fieldnames(handles.fI),handles.selectedFootage))
                
                [handles.dffitExp.(handles.selectedFootage), handles.dfgoffitExp.(handles.selectedFootage), handles.dfmobhalffitExp.(handles.selectedFootage), handles.dfuncerfitExp.(handles.selectedFootage)] =...
                    fitExp(handles.fI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage),'double');
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        end
    case 'Uniform Circle'
        if get(handles.norm_R,'Value') == 1
            if any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
                
                [handles.rfitUniCirc.(handles.selectedFootage), handles.rgofUniCirc.(handles.selectedFootage), handles.runcerUniCirc.(handles.selectedFootage)] =...
                    fitUniCirc(handles.rIb.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_D,'Value') == 1 
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
                
                [handles.dfitUniCirc.(handles.selectedFootage), handles.dgofUniCirc.(handles.selectedFootage), handles.duncerUniCirc.(handles.selectedFootage)] =...
                    fitUniCirc(handles.dI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_F,'Value') == 1
            if any(strcmp(fieldnames(handles),'fI')) && any(strcmp(fieldnames(handles.fI),handles.selectedFootage))
                
                [handles.ffitUniCirc.(handles.selectedFootage), handles.fgofUniCirc.(handles.selectedFootage), handles.funcerUniCirc.(handles.selectedFootage)] =...
                    fitUniCirc(handles.fI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        end
        
    case 'Rectangular'
        pixwid = str2double(get(handles.pixel_Width,'string'))*10^(-6);
        if strcmp(get(handles.bleach_Width,'String'),'auto')
            if any(strcmp(fieldnames(handles),'rectWidth')) && any(strcmp(fieldnames(handles.rectWidth),handles.selectedFootage))&&handles.rectWidth.(handles.selectedFootage)>0
                w = handles.rectWidth.(handles.selectedFootage)*pixwid;
            else
                w = regionprops(handles.bleachMask.(handles.selectedFootage), 'MinorAxisLength');
                w = w.MinorAxisLength*pixwid;
            end
        else
            w = str2double(get(handles.bleach_Width,'String'))*pixwid;
        end
        if get(handles.norm_R,'Value') == 1
            if any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
                  
                [handles.rfitRect.(handles.selectedFootage), handles.rgofRect.(handles.selectedFootage), handles.runcerRect.(handles.selectedFootage)] =...
                    fitRect(handles.rIb.(handles.selectedFootage),handles.show_Footage,w, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_D,'Value') == 1 %|| get(handles.norm_F,'Value') == 1
            %set(handles.norm_D,'Value',1);
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
                
                [handles.dfitRect.(handles.selectedFootage), handles.dgofRect.(handles.selectedFootage), handles.duncerRect.(handles.selectedFootage)] =...
                    fitRect(handles.dI.(handles.selectedFootage),handles.show_Footage,w, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_F,'Value') == 1
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
                
                [handles.ffitRect.(handles.selectedFootage), handles.fgofRect.(handles.selectedFootage), handles.funcerRect.(handles.selectedFootage)] =...
                    fitRect(handles.fI.(handles.selectedFootage),handles.show_Footage,w, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        end
            
    case 'Gaussian'
        if get(handles.norm_R,'Value') == 1
            if any(strcmp(fieldnames(handles),'rIb')) && any(strcmp(fieldnames(handles.rIb),handles.selectedFootage))
                  
                [handles.rfitGaussian.(handles.selectedFootage), handles.rgofGaussian.(handles.selectedFootage), handles.runcerGaussian.(handles.selectedFootage)] =...
                    fitGauss(handles.rIb.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
        elseif get(handles.norm_D,'Value') == 1 || get(handles.norm_F,'Value') == 1
            set(handles.norm_D,'Value',1);
            if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
                
                [handles.dfitGaussian.(handles.selectedFootage), handles.dgofGaussian.(handles.selectedFootage), handles.duncerGaussian.(handles.selectedFootage)] =...
                    fitGauss(handles.dI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
            else
                set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
            end
%         elseif get(handles.norm_F,'Value') == 1
%             if any(strcmp(fieldnames(handles),'dI')) && any(strcmp(fieldnames(handles.dI),handles.selectedFootage))
%                 
%                 [handles.ffitGaussian.(handles.selectedFootage), handles.fgofGaussian.(handles.selectedFootage), handles.funcerGaussian.(handles.selectedFootage)] =...
%                     fitGauss(handles.dI.(handles.selectedFootage),handles.show_Footage, handles.time.(handles.selectedFootage));
%             else
%                 set(handles.generate_Intensity,'ForegroundColor',[1,0,0]);
%             end
        end
    otherwise
        set(handles.fit_Method,'Backgroundcolor',[1,0,0]);
end
set(hObject,'String','Fit Kinetics')
guidata(hObject,handles);

% --- Executes on selection change in fit_Method.
function fit_Method_Callback(hObject, eventdata, handles)
% hObject    handle to fit_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fit_Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_Method
set(handles.fit_Method,'Backgroundcolor','white');


% --- Executes during object creation, after setting all properties.
function fit_Method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_Data.
function get_Data_Callback(hObject, eventdata, handles)
% hObject    handle to get_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% try
    % show GOF
    dialog1 = dialog('WindowStyle','normal','Position',[200,200,750,300]);
    set(handles.get_Data,'ForegroundColor','Black');
    
    contents = cellstr(get(handles.fit_Method,'String'));
    strfit = contents{get(handles.fit_Method,'Value')};
    mobhalf=[];
    switch strfit
        case 'Single Expoential'
            if get(handles.norm_R,'Value') == 1
                if any(strcmp(fieldnames(handles),'srfitExp')) && any(strcmp(fieldnames(handles.srfitExp),handles.selectedFootage))
                    fitted = handles.srfitExp.(handles.selectedFootage);
                    gof = handles.srgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.srmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.sruncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Single Expoential Raw');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_D,'Value') == 1 
                if any(strcmp(fieldnames(handles),'sdfitExp')) && any(strcmp(fieldnames(handles.sdfitExp),handles.selectedFootage))
                    fitted = handles.sdfitExp.(handles.selectedFootage);
                    gof = handles.sdgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.sdmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.sduncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Single Expoential Double Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_F,'Value') == 1
                if any(strcmp(fieldnames(handles),'sffitExp')) && any(strcmp(fieldnames(handles.sffitExp),handles.selectedFootage))
                    fitted = handles.sffitExp.(handles.selectedFootage);
                    gof = handles.sfgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.sfmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.sfuncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Single Expoential Full Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            end
%             text(.2,.1, {'Halflife and Mobile Fraction',evalc('disp(mobhalf)')},'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white');
        case 'Double Expoential'
            if get(handles.norm_R,'Value') == 1
                if any(strcmp(fieldnames(handles),'drfitExp')) && any(strcmp(fieldnames(handles.drfitExp),handles.selectedFootage))
                    fitted = handles.drfitExp.(handles.selectedFootage);
                    gof = handles.drgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.drmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.druncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Double Expoential Raw');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_D,'Value') == 1 
                if any(strcmp(fieldnames(handles),'ddfitExp')) && any(strcmp(fieldnames(handles.ddfitExp),handles.selectedFootage))
                    fitted = handles.ddfitExp.(handles.selectedFootage);
                    gof = handles.ddgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.ddmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.dduncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Double Expoential Double Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_F,'Value') == 1
                if any(strcmp(fieldnames(handles),'dffitExp')) && any(strcmp(fieldnames(handles.dffitExp),handles.selectedFootage))
                    fitted = handles.dffitExp.(handles.selectedFootage);
                    gof = handles.dfgoffitExp.(handles.selectedFootage);
                    mobhalf = handles.dfmobhalffitExp.(handles.selectedFootage);
                    uncer = handles.dfuncerfitExp.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Double Expoential Full Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            end
%             text(.2,.1, {'Halflife and Mobile Fraction',evalc('disp(mobhalf)')},'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white','Interpreter','none');
        case 'Uniform Circle'
            if get(handles.norm_R,'Value') == 1
                if any(strcmp(fieldnames(handles),'rfitUniCirc')) && any(strcmp(fieldnames(handles.rfitUniCirc),handles.selectedFootage))
                    fitted = handles.rfitUniCirc.(handles.selectedFootage);
                    gof = handles.rgofUniCirc.(handles.selectedFootage);
                    uncer = handles.runcerUniCirc.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Uniform Circle Raw');              
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_D,'Value') == 1 
                if any(strcmp(fieldnames(handles),'dfitUniCirc')) && any(strcmp(fieldnames(handles.dfitUniCirc),handles.selectedFootage))
                    fitted = handles.dfitUniCirc.(handles.selectedFootage);
                    gof = handles.dgofUniCirc.(handles.selectedFootage);
                    uncer = handles.duncerUniCirc.(handles.selectedFootage); 
                    set(dialog1,'Name', 'Fitting Data: Uniform Circle Double Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_F,'Value') == 1
                if any(strcmp(fieldnames(handles),'ffitUniCirc')) && any(strcmp(fieldnames(handles.ffitUniCirc),handles.selectedFootage))
                    fitted = handles.ffitUniCirc.(handles.selectedFootage);
                    gof = handles.fgofUniCirc.(handles.selectedFootage);
                    uncer = handles.funcerUniCirc.(handles.selectedFootage); 
                    set(dialog1,'Name', 'Fitting Data: Uniform Circle Full Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            end
        case 'Rectangular'
            if get(handles.norm_R,'Value') == 1
                if any(strcmp(fieldnames(handles),'rfitRect')) && any(strcmp(fieldnames(handles.rfitRect),handles.selectedFootage))
                    fitted = handles.rfitRect.(handles.selectedFootage);
                    gof = handles.rgofRect.(handles.selectedFootage);
                    uncer = handles.runcerRect.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Rectangular Raw');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_D,'Value') == 1
                if any(strcmp(fieldnames(handles),'dfitRect')) && any(strcmp(fieldnames(handles.dfitRect),handles.selectedFootage))
                    fitted = handles.dfitRect.(handles.selectedFootage);
                    gof = handles.dgofRect.(handles.selectedFootage);
                    uncer = handles.duncerRect.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Rectangular Double Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_F,'Value') == 1
                if any(strcmp(fieldnames(handles),'ffitRect')) && any(strcmp(fieldnames(handles.ffitRect),handles.selectedFootage))
                    fitted = handles.ffitRect.(handles.selectedFootage);
                    gof = handles.fgofRect.(handles.selectedFootage);
                    uncer = handles.funcerRect.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Rectangular Full Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            end
%             text(.2,.1, {'Width of Rectangle: ',evalc('disp(w)')},'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white','Interpreter','none');
        case 'Gaussian'
            if get(handles.norm_R,'Value') == 1
                if any(strcmp(fieldnames(handles),'rfitGaussian')) && any(strcmp(fieldnames(handles.rfitGaussian),handles.selectedFootage))
                    fitted = handles.rfitGaussian.(handles.selectedFootage);
                    gof = handles.rgofGaussian.(handles.selectedFootage);
                    uncer = handles.runcerGaussian.(handles.selectedFootage);
                    set(dialog1,'Name', 'Fitting Data: Gaussian Raw');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            elseif get(handles.norm_D,'Value') == 1 || get(handles.norm_F,'Value') == 1
                set(handles.norm_D,'Value',1);
                if any(strcmp(fieldnames(handles),'dfitGaussian')) && any(strcmp(fieldnames(handles.dfitGaussian),handles.selectedFootage))
                    fitted = handles.dfitGaussian.(handles.selectedFootage);
                    gof = handles.dgofGaussian.(handles.selectedFootage);
                    uncer = handles.duncerGaussian.(handles.selectedFootage); 
                    set(dialog1,'Name', 'Fitting Data: Gaussian Double Normalised');
                else
                    set(handles.fit_Kinetics,'ForegroundColor',[1,0,0]);
                end
            end
    end

    % Diffusion Constant and Width
    if exist('fitted','var')
        if strcmp('auto',get(handles.bleach_Width,'String'));
            %auto rectangle
            if any(strcmp(fieldnames(handles),'rectWidth')) && any(strcmp(fieldnames(handles.rectWidth),handles.selectedFootage))&&strcmp(strfit,'Rectangular')&&handles.rectWidth.(handles.selectedFootage)>0
                w = handles.rectWidth.(handles.selectedFootage)*str2double(get(handles.pixel_Width,'String'))*10^(-6);
                uncer.w = 0.1*handles.rectWidth.(handles.selectedFootage)*str2double(get(handles.pixel_Width,'String'))*10^(-6);%TODO  
            elseif strcmp(strfit,'Rectangular')%auto rectangle no manual rect mask
                wminor = regionprops(handles.bleachMask.(handles.selectedFootage), 'MinorAxisLength');
                wmajor = regionprops(handles.bleachMask.(handles.selectedFootage), 'MajorAxisLength');
                w = wminor.MinorAxisLength*str2double(get(handles.pixel_Width,'string'))*10^(-6);
                uncer.w = wminor.MinorAxisLength^2/wmajor.MajorAxisLength*str2double(get(handles.pixel_Width,'string'))*10^(-6);%TODO
            else%auto no rectangle
                pixrad2 = sum(sum(handles.bleachMask.(handles.selectedFootage)))/pi; %Circle radius squared
                w = sqrt(pixrad2)*str2double(get(handles.pixel_Width,'String'))*10^(-6); %Circle radius squared
                closedw = sqrt(sum(sum(imclose(handles.bleachMask.(handles.selectedFootage),strel('disk',ceil(sqrt(pixrad2)*0.682))))))*str2double(get(handles.pixel_Width,'String'))*10^(-6);% TODO:Check
                openedw = sqrt(sum(sum(imopen(handles.bleachMask.(handles.selectedFootage),strel('disk',ceil(sqrt(pixrad2)*0.682))))))*str2double(get(handles.pixel_Width,'String'))*10^(-6);
                uncer.w = (closedw - openedw)/2; % uncertinity in circle radius squared
            end
        else %non auto
            w = str2double(get(handles.bleach_Width,'String'));
            if isreal(w)|| isnumeric(w) || ~isnan(w)||~isempty(w)|| w > 0
                uncer.w = 0.1*handles.rectWidth.(handles.selectedFootage)*str2double(get(handles.pixel_Width,'string'));%Check    
            else
                set(handles.bleach_Width,'BackgroundColor',[1,0,0])
            end
        end
        handles.bleachWidth.(handles.selectedFootage) = w;
        
        [data1,data2] = diffusionData(fitted, uncer, gof, w, mobhalf);
        handles.data1.(handles.selectedFootage) = data1;
        handles.data2.(handles.selectedFootage) = data2;

    %     text(-0.1,1, formula(fitted),'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white','Interpreter','tex');
    %     text(0,.6, {'Uncertainties',evalc('disp(uncer)')},'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white','Interpreter','none');
    %     text(.5,.6, {'Goodness of Fit Data',evalc('disp(gof)')},'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','backgroundcolor','white','Interpreter','none');

        text(-0.1,1, data2,'FontSize',14,'FontWeight','bold','VerticalAlignment','top','HorizontalAlignment','left','BackgroundColor','white','Interpreter','latex');
        axis off
    end
    uicontrol('Style', 'pushbutton', 'String', 'Export Data','Callback',...
        {@export_Data_Callback,handles});
% catch err
%     switch err.identifier
%         case'MATLAB:nonExistentField'
%             set(handles.fit_Kinetics,'foregroundcolor', [1,0,0]);
%     end
%         
% end
guidata(hObject,handles);

function pixel_Width_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_Width as text
%        str2double(get(hObject,'String')) returns contents of pixel_Width as a double
handles.pixelWidth = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pixel_Width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_Data.
function export_Data_Callback(hObject, eventdata, handles)
% hObject    handle to export_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if any(strcmp(fieldnames(handles),'data1')) && any(strcmp(fieldnames(handles.data1),handles.selectedFootage))
    
    output_filename = strcat(handles.selectedFootage,'_Data','.txt'); % name of text file to save to.
    fileID = fopen(output_filename,'wt');
    data1 = handles.data1.(handles.selectedFootage);
    nams = fields(data1);
    for k = 1:length(nams)
        if strcmp(nams{k},'formula')
            fprintf(fileID,'%s: %s \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'D')
            fprintf(fileID,'%s = (%d +/- %d)/m^2s^-1 \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'w')
            fprintf(fileID,'%s = (%d +/- %d)/m \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'td')
            fprintf(fileID,'%s = (%d +/- %d)/s \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'tau')
            fprintf(fileID,'%s = (%d +/- %d)/s \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'halflife')
            fprintf(fileID,'%s = (%d +/- %d)/s \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'b')
            fprintf(fileID,'%s = (%d +/- %d)/s^-1 \n',nams{k},data1.(nams{k}));
        elseif strcmp(nams{k},'d')
            fprintf(fileID,'%s = (%d +/- %d)/s^-1 \n',nams{k},data1.(nams{k}));
        elseif length(data1.(nams{k})) == 1
            fprintf(fileID,'%s = %d \n',nams{k},data1.(nams{k}));
        else
            fprintf(fileID,'%s = (%d +/- %d) \n',nams{k},data1.(nams{k}));
        end
    end    
    
    fclose(fileID);
    drawnow;
else
    set(handles.get_Data,'ForegroundColor',[1,0,0]);
end

function bleach_Width_Callback(hObject, eventdata, handles)
% hObject    handle to bleach_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bleach_Width as text
%        str2double(get(hObject,'String')) returns contents of bleach_Width as a double


% --- Executes during object creation, after setting all properties.
function bleach_Width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bleach_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aver_Post_Bleach_Callback(hObject, eventdata, handles)
% hObject    handle to aver_Post_Bleach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aver_Post_Bleach as text
%        str2double(get(hObject,'String')) returns contents of aver_Post_Bleach as a double


% --- Executes during object creation, after setting all properties.
function aver_Post_Bleach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aver_Post_Bleach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
