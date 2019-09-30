function varargout = gen_compare(varargin)
% GEN_COMPARE MATLAB code for gen_compare.fig
%      GEN_COMPARE, by itself, creates a new GEN_COMPARE or raises the existing
%      singleton*.
%
%      H = GEN_COMPARE returns the handle to a new GEN_COMPARE or the handle to
%      the existing singleton*.
%
%      GEN_COMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEN_COMPARE.M with the given input arguments.
%
%      GEN_COMPARE('Property','Value',...) creates a new GEN_COMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gen_compare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop. All inputs are passed to gen_compare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gen_compare

% Last Modified by GUIDE v2.5 29-Sep-2019 23:38:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gen_compare_OpeningFcn, ...
                   'gui_OutputFcn',  @gen_compare_OutputFcn, ...
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


% --- Executes just before gen_compare is made visible.
function gen_compare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gen_compare (see VARARGIN)

% Choose default command line output for gen_compare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gen_compare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gen_compare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in image1.
function image1_Callback(hObject, eventdata, handles)
% hObject    handle to image1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfile('*.*','Choose an iris image');
image = strcat(pathname,filename);
fig=imread(image);
setappdata(handles.figure1,'imagePath',image);
setappdata(handles.figure1,'IrisImg1',fig);
p1 = subplot(3,2,1);
imshow(fig);



% --- Executes on button press in image2.
function image2_Callback(hObject, eventdata, handles)
% hObject    handle to image2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfile('*.*','Choose an iris image');
fig=imread(strcat(pathname,filename));
setappdata(handles.figure1,'IrisImg2',fig);
p2 = subplot(3,2,2);
imshow(fig);


% --- Executes on button press in preProcess.
function preProcess_Callback(hObject, eventdata, handles)
% hObject    handle to preProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eImage = getappdata(handles.figure1,'enhancedImage');
img1 = getappdata(handles.figure1,'IrisImg1');
img2 = getappdata(handles.figure1,'IrisImg2');
se = strel('disk',3);
se2 = strel('disk',3);
img1_opened = imopen(eImage,se);
img1_closed = imclose(eImage,se2);
img2_opened = imopen(img2,se);
img2_closed = imclose(img2,se2);
subplot(2,4,1);
imshow(eImage);
subplot(2,4,2);
imshow(img2);
subplot(2,4,3);
imshow(img1_opened);
subplot(2,4,4);
imshow(img1_closed);
subplot(2,4,5);
imshow(img2_opened);
subplot(2,4,6);
imshow(img2_closed);
thresh = 0.25;
%creating bianry mask of all the images 
binary_open1 = im2bw(img1_opened,thresh);
binary_closed1 = imbinarize(img1_closed,thresh);
binary_open2 = im2bw(img2_opened,thresh);
binary_closed2 = imbinarize(img2_closed,thresh);
subplot(2,4,7)
imshow(binary_open1);
subplot(2,4,8)
imshow(binary_open2);


% --- Executes on button press in templateGen.
function templateGen_Callback(hObject, eventdata, handles)
% hObject    handle to templateGen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eye=getappdata(handles.figure1,'IrisImg1');
[local xc yc time]=localisation2(eye,0.2);
[ci cp out time]=thresh(local,50,200);
[ring,parr]=normaliseiris(local,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',100,300);
[temp th tv]=gen_templateVVV(parr);
setappdata(handles.figure1,'temp1',temp);
p3 = subplot(3,2,5);
imshow(temp);

eye2=getappdata(handles.figure1,'IrisImg2');
[local2 xc2 yc2 time2]=localisation2(eye2,0.2);
[ci2 cp2 out2 time2]=thresh(local2,50,200);
[ring2,parr2]=normaliseiris(local2,ci2(2),ci2(1),ci2(3),cp2(2),cp2(1),cp2(3),'normal.bmp',100,300);
[temp2 th2 tv2]=gen_templateVVV(parr2);
setappdata(handles.figure1,'temp2',temp2);
p4 = subplot(3,2,6);
imshow(temp2);

    


% --- Executes on button press in compare.
function compare_Callback(hObject, eventdata, handles)
% hObject    handle to compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% eye=getappdata(handles.figure1,'IrisImg1');
% [local xc yc time]=localisation2(eye,0.2);
% [ci cp out time]=thresh(local,50,200);
% [ring,parr]=normaliseiris(local,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',100,300);
% [temp th tv]=gen_templateVVV(parr);
% setappdata(handles.figure1,'temp1',temp);
temp_1 = getappdata(handles.figure1,'temp1');


% eye2=getappdata(handles.figure1,'IrisImg2');
% [local2 xc2 yc2 time2]=localisation2(eye2,0.2);
% [ci2, cp2, out2, time2]=thresh(local2,50,200);
% [ring2,parr2]=normaliseiris(local2,ci2(2),ci2(1),ci2(3),cp2(2),cp2(1),cp2(3),'normal.bmp',100,300);
% [temp2 th2 tv2]=gen_templateVVV(parr2);
% setappdata(handles.figure1,'temp1',temp2);
temp_2 = getappdata(handles.figure1,'temp2');

hd=hammingdist(temp_1, temp_2);
set(handles.Result,'Visible','on');
set(handles.hamD,'Visible','on');
set(handles.hamD,'String',hd);
if(hd>=0 && hd<=0.2)
    set(handles.hamD,'Visible','on');
    set(handles.hammingDistance,'Visible','on');
    set(handles.Success,'Visible','on');
    set(handles.Genuine,'Visible','on');
    set(handles.Fail,'Visible','off');
    set(handles.Impositor,'Visible','off');
    set(handles.Status,'Visible','on');
    set(handles.Result,'Visible','on');

else
    set(handles.hamD,'Visible','on');
    set(handles.hammingDistance,'Visible','on');
    set(handles.Fail,'Visible','on');
    set(handles.Genuine,'Visible','off');
    set(handles.Success,'Visible','off');
    set(handles.Impositor,'Visible','on');
    set(handles.Status,'Visible','on');
    set(handles.Result,'Visible','on');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h1 = subplot(2,4,1);
h2 = subplot(2,4,2);
h3 = subplot(2,4,3);
h4 = subplot(2,4,4);
h5 = subplot(2,4,5);
h6 = subplot(2,4,6);
h7 = subplot(2,4,7);
h8 = subplot(2,4,8);
cla(h1);
cla(h2);
cla(h3);
cla(h4);
cla(h5);
cla(h6);
cla(h7);
cla(h8);
p1 = subplot(3,2,1);
p2 = subplot(3,2,2);
p3 = subplot(3,2,5);
p4 = subplot(3,2,6);
cla(p1);
cla(p2);
cla(p3);
cla(p4);
set(handles.Success,'Visible','off');
set(handles.Genuine,'Visible','off');
set(handles.Fail,'Visible','off');
set(handles.Impositor,'Visible','off');
set(handles.hamD,'Visible','off');
set(handles.hammingDistance,'Visible','off');
set(handles.Status,'Visible','off');
set(handles.Result,'Visible','off');


% --- Executes on button press in Enhance.
function Enhance_Callback(hObject, eventdata, handles)
% hObject    handle to Enhance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = getappdata(handles.figure1,'imagePath');
enhImg = redColor(image);
setappdata(handles.figure1,'enhancedImage',enhImg);


% --- Executes on button press in daugSegmentation.
function daugSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to daugSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eye=getappdata(handles.figure1,'IrisImg1');
[ci cp out time]=thresh(eye,50,200);
%subplot(1,2,2),imshow(out);
subplot(3,2,3),imshow(out);


% --- Executes on button press in proposedSegmentation.
function proposedSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to proposedSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eye=getappdata(handles.figure1,'IrisImg1');
eye=localisation2(eye,0.2)
[ci cp out time]=thresh(eye,50,200);
subplot(3,2,4),imshow(out);
hu