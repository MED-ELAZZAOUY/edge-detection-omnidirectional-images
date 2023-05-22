function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 07-Mar-2023 14:46:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;
set(handles.axes1,'visible','off')
set(handles.axes2,'visible','off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GRAY
[file,path] = uigetfile({'*.*'});
img_loc = fullfile(path,file);
RGB = imread(img_loc);
axes(handles.axes1);
imshow(RGB);
%GRAY = rgb2gray(RGB);
GRAY = RGB;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GRAY
K = get(handles.popupmenu1,'value');
switch K
    case 2
        % EDGE = edge(GRAY,'Sobel');
        input_image = double(GRAY);
        % Pre-allocate the filtered_image matrix with zeros
        filtered_image = zeros(size(input_image));

        % Sobel Operator Mask
        Mx = [-1 0 1; -2 0 2; -1 0 1];
        My = [-1 -2 -1; 0 0 0; 1 2 1];

        % Edge Detection Process
        % When i = 1 and j = 1, then filtered_image pixel
        % position will be filtered_image(2, 2)
        % The mask is of 3x3, so we need to traverse
        % to filtered_image(size(input_image, 1) - 2
        %, size(input_image, 2) - 2)
        % Thus we are not considering the borders.
        for i = 1:size(input_image, 1) - 2
            for j = 1:size(input_image, 2) - 2

                % Gradient approximations
                Gx = sum(sum(Mx.*input_image(i:i+2, j:j+2)));
                Gy = sum(sum(My.*input_image(i:i+2, j:j+2)));

                % Calculate magnitude of vector
                filtered_image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);

            end
        end

        % Displaying Filtered Image
        %filtered_image = uint8(filtered_image);
        %figure, imshow(filtered_image); title('Filtered Image');

        % Define a threshold value
        thresholdValue = 100; % varies between [0 255]
        output_image = max(filtered_image, thresholdValue);
        output_image(output_image == round(thresholdValue)) = 0;
        
        EDGE = output_image;
        % Displaying Output Image
        %EDGE = im2bw(output_image);

    case 3
        % Convert the truecolor RGB image to the grayscale image
        %input_image = rgb2gray(input_image);

        % Convert the image to double
        input_image = double(GRAY);

        % Pre-allocate the filtered_image matrix with zeros
        filtered_image = zeros(size(input_image));

        % Prewitt Operator Mask
        Mx = [-1 0 1; -1 0 1; -1 0 1];
        My = [-1 -1 -1; 0 0 0; 1 1 1];

        % Edge Detection Process
        % When i = 1 and j = 1, then filtered_image pixel
        % position will be filtered_image(2, 2)
        % The mask is of 3x3, so we need to traverse
        % to filtered_image(size(input_image, 1) - 2
        %, size(input_image, 2) - 2)
        % Thus we are not considering the borders.
        for i = 1:size(input_image, 1) - 2
            for j = 1:size(input_image, 2) - 2

                % Gradient approximations
                Gx = sum(sum(Mx.*input_image(i:i+2, j:j+2)));
                Gy = sum(sum(My.*input_image(i:i+2, j:j+2)));

                % Calculate magnitude of vector
                filtered_image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);

            end
        end

        % Displaying Filtered Image
        %filtered_image = uint8(filtered_image);
        %figure, imshow(filtered_image); title('Filtered Image');

        % Define a threshold value
        thresholdValue = 100; % varies between [0 255]
        output_image = max(filtered_image, thresholdValue);
        output_image(output_image == round(thresholdValue)) = 0;

        EDGE = output_image;
        % Displaying Output Image
        %output_image = im2bw(output_image);
        %figure, imshow(output_image); title('Prewitt');
            
        %EDGE = edge(GRAY,'Prewitt');
    case 4
        % MATLAB Code | Robert Operator from Scratch

        % Displaying Input Image
        input_image = uint8(GRAY);
        %figure, imshow(input_image); title('Input Image');

        % Convert the truecolor RGB image to the grayscale image
        %input_image = rgb2gray(input_image);

        % Convert the image to double
        input_image = double(input_image);

        % Pre-allocate the filtered_image matrix with zeros
        filtered_image = zeros(size(input_image));

        % Robert Operator Mask
        Mx = [1 0; 0 -1];
        My = [0 1; -1 0];

        % Edge Detection Process
        % When i = 1 and j = 1, then filtered_image pixel
        % position will be filtered_image(1, 1)
        % The mask is of 2x2, so we need to traverse
        % to filtered_image(size(input_image, 1) - 1
        %, size(input_image, 2) - 1)
        for i = 1:size(input_image, 1) - 1
            for j = 1:size(input_image, 2) - 1

                % Gradient approximations
                Gx = sum(sum(Mx.*input_image(i:i+1, j:j+1)));
                Gy = sum(sum(My.*input_image(i:i+1, j:j+1)));

                % Calculate magnitude of vector
                filtered_image(i, j) = sqrt(Gx.^2 + Gy.^2);

            end
        end

        % Displaying Filtered Image
        %filtered_image = uint8(filtered_image);
        %figure, imshow(filtered_image); title('Filtered Image');

        % Define a threshold value
        thresholdValue = 100; % varies between [0 255]
        output_image = max(filtered_image, thresholdValue);
        output_image(output_image == round(thresholdValue)) = 0;

        EDGE = output_image;
        % Displaying Output Image
        %output_image = im2bw(output_image);
        %figure, imshow(output_image); title('Edge Detected Image');
        
        %EDGE = edge(GRAY,'Roberts');
    case 5
        EDGE = edge(GRAY,'LOG');
    case 6
        I = double(GRAY)/255;
        J = canny_edge_detection(I, 1, 0.01, 0.05);
        EDGE = J;
        %EDGE = edge(GRAY,'Canny');
    otherwise
        disp('No filter');
end

axes(handles.axes2);
if isequal(K,1)
    imshow(GRAY);
else
    imshow(EDGE);
end
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
