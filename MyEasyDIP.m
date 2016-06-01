function varargout = MyEasyDIP(varargin)
% MYEASYDIP MATLAB code for MyEasyDIP.fig
%      MYEASYDIP, by itself, creates a new MYEASYDIP or raises the existing
%      singleton*.
%
%      H = MYEASYDIP returns the handle to a new MYEASYDIP or the handle to
%      the existing singleton*.
%
%      MYEASYDIP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYEASYDIP.M with the given input arguments.
%
%      MYEASYDIP('Property','Value',...) creates a new MYEASYDIP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyEasyDIP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyEasyDIP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyEasyDIP

% Last Modified by GUIDE v2.5 28-Apr-2016 18:53:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyEasyDIP_OpeningFcn, ...
                   'gui_OutputFcn',  @MyEasyDIP_OutputFcn, ...
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


% --- Executes just before MyEasyDIP is made visible.
function MyEasyDIP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyEasyDIP (see VARARGIN)

% Choose default command line output for MyEasyDIP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyEasyDIP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyEasyDIP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BtnReadImg.
function BtnReadImg_Callback(hObject, eventdata, handles)
% hObject    handle to BtnReadImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;     %用于存储原始图像数据
global img_color;       %用于保存图片是否彩色图片
[filename,pathname] = uigetfile({'*.*';'*.JPG';'*.JPEG';'*jpg';'*.bmp'},'选择要处理的图片文件');      %弹出对话框，选择图像文件
filename = [pathname filename];
if filename
    img_ori = imread(filename);
    img_ori = im2double(img_ori);
    if size(img_ori,3) == 1
        img_color = 0;
        set(handles.CheckBoxColorOrNot, 'Value', 0);
    else
        img_color = 1;
        set(handles.CheckBoxColorOrNot, 'Value', 1);
    end
    axes(handles.ImgBox);
    imshow(img_ori)
end

% --- Executes on button press in BtnResetImg.
function BtnResetImg_Callback(hObject, eventdata, handles)
% hObject    handle to BtnResetImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
axes(handles.ImgBox);
imshow(img_ori);


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CheckBoxColorOrNot.
function CheckBoxColorOrNot_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBoxColorOrNot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBoxColorOrNot


% --- Executes on button press in BtnSelectColor.
function BtnSelectColor_Callback(hObject, eventdata, handles)
% hObject    handle to BtnSelectColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global color;     %选择要提取的颜色
c = uisetcolor;
if size(c,2)==3
    color = c;
    set(handles.TextColor, 'BackgroundColor', c);
    drawnow
end

% --- Executes on slider movement.
function SliderTolerance_Callback(hObject, eventdata, handles)
% hObject    handle to SliderTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderTolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in BtnExtractColor.
function BtnExtractColor_Callback(hObject, eventdata, handles)
% hObject    handle to BtnExtractColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
global color;
img_color_extract = zeros(size(img_ori));
if img_color
    tolerance = get(handles.SliderTolerance, 'Value') * sqrt(3);
    diff = (img_ori(:,:,1) - color(1)).^2 + (img_ori(:,:,2) - color(2)).^2 + (img_ori(:,:,3) - color(3)).^2;
    diff = sqrt(diff);
    if get(handles.CheckBoxIsInverted, 'Value')
        array_wanted = find(diff >= tolerance);
    else
        array_wanted = find(diff <= tolerance);
    end
    R = img_ori(:,:,1);
    G = img_ori(:,:,2);
    B = img_ori(:,:,3);
    tmp = zeros(size(img_ori(:,:,1)));
    tmp(array_wanted) = R(array_wanted);
    img_color_extract(:,:,1) = tmp;
    tmp(array_wanted) = G(array_wanted);
    img_color_extract(:,:,2) = tmp;
    tmp(array_wanted) = B(array_wanted);
    img_color_extract(:,:,3) = tmp;
else
    tolerance = get(handles.SliderTolerance, 'Value');
    diff = img_ori - (0.2989 * color(1) + 0.5870 * color(2) + 0.1140 * color(3));       %将所选取颜色转换为灰度值
    diff = abs(diff);
    if get(handles.CheckBoxIsInverted, 'Value')
        array_wanted = find(diff >= tolerance);
    else
        array_wanted = find(diff <= tolerance);
    end
    img_color_extract(array_wanted) = img_ori(array_wanted);
end
axes(handles.ImgBox);
imshow(img_color_extract);


% --- Executes on button press in CheckBoxIsInverted.
function CheckBoxIsInverted_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBoxIsInverted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBoxIsInverted


% --- Executes on button press in BtnEdgeSobel.
function BtnEdgeSobel_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgeSobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'sobel');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'sobel');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);



% --- Executes on button press in BtnEdgeRoberts.
function BtnEdgeRoberts_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgeRoberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'roberts');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'roberts');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);

% --- Executes on button press in BtnEdgePrewitt.
function BtnEdgePrewitt_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgePrewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'prewitt');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'prewitt');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);

% --- Executes on button press in BtnEdgeLog.
function BtnEdgeLog_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgeLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'log');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'log');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);

% --- Executes on button press in BtnEdgeCanny.
function BtnEdgeCanny_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgeCanny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'canny');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'canny');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);

% --- Executes on button press in BtnEdgeZerocross.
function BtnEdgeZerocross_Callback(hObject, eventdata, handles)
% hObject    handle to BtnEdgeZerocross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_ori;
global img_color;
img_edge = img_ori;
if img_color
    tmp = rgb2gray(img_ori);
    tmp = edge(tmp,'zerocross');
    img_edge(:,:,1) = img_edge(:,:,1).*tmp;
    img_edge(:,:,2) = img_edge(:,:,2).*tmp;
    img_edge(:,:,3) = img_edge(:,:,3).*tmp;    
else
    tmp = edge(img_edge,'zerocross');
    img_edge = img_edge.*tmp;
end
axes(handles.ImgBox);
imshow(img_edge);