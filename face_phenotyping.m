function varargout = face_phenotyping(varargin)
% FACE_PHENOTYPING call without arguments to run phenotyping software.
%     This software allows the phenotyping of 19 ordinal phenotypes.
%     Default GUI window size 1206x738 pixels.
%     The window is resizable. But some of the button or text sizes may become too small if shrunk.
%     Enlarging should work fine, in fact is encouraged if you have a bigger screen.
%     This graphical (GUI) function has two components:
%     face_phenotyping.fig and face_phenotyping.m.
%     The accompanying file help.mat contains sample images for each phenotype.
%     These three files should be placed together in a folder.
%     There should be two subfolders in the same folder, named ‘front’ and ‘side’, 
%     containing frontal and side facial photographs for each person.
%     Three example faces are provided with this software inside front & side subfolders.
%     Check the accompanying file face_phenotyping_helpfile.pdf for detailed help and instructions.
%     --------------------------------------------------------------------------------------
%     This is face phenotyping software v1.4, released on 19 May 2016.
%     This software was developed at University College London for use in the CANDELA project:
%     http://www.ucl.ac.uk/silva/candela
%     Software developed by Kaustubh Adhikari.
%     Drawings by Macarena Fuentes-Guajardo and Elizabeth Guajardo Celsi.
%     This software including the drawings is released for public use under the Creative Commons CC BY-NC-SA 4.0 license (Attribution-NonCommercial-ShareAlike 4.0 International).
%     If using the software, please cite:
%     Adhikari, K. et al. A genome-wide association scan implicates DCHS2, RUNX2, GLI3, PAX1 and EDAR in human facial variation. Nat. Commun. 7:11616 doi: 10.1038/ncomms11616 (2016).
%     Phenotypes and phenotype categories are derived from:
%     Ritz-Timme, S. et al. A new atlas for the evaluation of facial features: advantages, limits, and applicability. Int J Legal Med 125, 301-6 (2011).
%     --------------------------------------------------------------------------------------

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @face_phenotyping_OpeningFcn, ...
                   'gui_OutputFcn',  @face_phenotyping_OutputFcn, ...
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


% --- Executes just before face_phenotyping is made visible.
function face_phenotyping_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for face_phenotyping
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(hObject,'Units','Normalized'); set(hObject,'Resize','on');
hdlall = findall(hObject,'-property','FontSize'); set(hdlall,'FontSize',8);
hdlall = findall(hObject,'-property','Units'); set(hdlall,'Units','Normalized');
hdlall = findall(hObject,'-property','Resize'); set(hdlall,'Resize','on');

if exist('help.mat','file')~=2, ermsg='The file help.mat containing sample images is not found in the current folder.'; errordlg(ermsg); error(ermsg); end;
if exist('front','dir')~=7, ermsg='There should be a subfolder named front, inside the current folder, containing frontal photographs.'; errordlg(ermsg); error(ermsg); end;
if exist('side','dir')~=7, ermsg='There should be a subfolder named side, inside the current folder, containing side photographs.'; errordlg(ermsg); error(ermsg); end;

global main oldir pickf picks help front side head nph fnames fnamess done count code pheno current tstart tend times curt
load help;

head=handles.head;
help=handles.help; set(help,'Visible','off');
front=handles.front; set(front,'Visible','off');
side=handles.side; set(side,'Visible','off');
nph=19;

set(handles.g1,'SelectedObject',[]);  set(handles.g2,'SelectedObject',[]);  set(handles.g3,'SelectedObject',[]);  set(handles.g4,'SelectedObject',[]);
set(handles.g5,'SelectedObject',[]);  set(handles.g6,'SelectedObject',[]);  set(handles.g7,'SelectedObject',[]);  set(handles.g8,'SelectedObject',[]);
set(handles.g9,'SelectedObject',[]);  set(handles.g10,'SelectedObject',[]); set(handles.g11,'SelectedObject',[]); set(handles.g12,'SelectedObject',[]);
set(handles.g13,'SelectedObject',[]); set(handles.g14,'SelectedObject',[]); set(handles.g15,'SelectedObject',[]); set(handles.g16,'SelectedObject',[]);
set(handles.g17,'SelectedObject',[]); set(handles.g18,'SelectedObject',[]); set(handles.g19,'SelectedObject',[]);

main=cd; oldir=cd;
pickf=[main '\front']; picks=[main '\side'];
cd(main);
l=dir('worklist.mat'); % worklist.mat is where work info is stored
if isempty(l) % starting afresh
    fnames=listfiles(pickf); fnamess=listfiles(picks);
    count=length(fnames); done=false(count,1); code=cell(count,1); pheno=zeros(count,nph); times=zeros(count,1); tstart=zeros(count,6); tend=tstart;
    for i=1:count, ap=fnames{i}; as=max(strfind(ap,'.'))-1; code{i}=ap(1:as); end;
    save('worklist.mat','fnames','fnamess','done','count','code','pheno','tstart','tend','times');
else
    load('worklist.mat'); % load the existing file
    fnames2=listfiles(pickf);  count=length(fnames2); % count current number of folders
    % files may change, fresh indexing needed
    done2=false(count,1); pheno2=zeros(count,nph); times2=zeros(count,1); tstart2=zeros(count,6); tend2=tstart2; id=0;
    for i=1:count,
        v=strcmpi(fnames2{i},fnames);
        if any(v), id=find(v,1,'first'); done2(i)=done(id); pheno2(i,:)=pheno(id,:); times2(i)=times(id); tstart2(i,:)=tstart(id,:); tend2(i,:)=tend(id,:); end; % match name and get status
    end
    fnames=fnames2; done=done2; pheno=pheno2; times=times2; tstart=tstart2; tend=tend2; clear id v fnames2 done2 pheno2 times2 tstart2 tend2;
    code=cell(count,1); fnamess=listfiles(picks);
    for i=1:count, ap=fnames{i}; as=max(strfind(ap,'.'))-1; code{i}=ap(1:as); end;
    save('worklist.mat','fnames','fnamess','done','count','code','pheno','tstart','tend','times');
end

if all(done), set(head,'String','All pictures processed already.'); cd(oldir); return; end;

mismatch=0;
if count~=length(fnamess),
    mismatch=1;
else
    for i=1:count, t1=fnames{i}; t2=fnamess{i}; tem=strcmpi(t1(1:7),t2(1:7)); if ~tem, mismatch=1; break; end; end;
end
if mismatch, set(head,'String','Photos for front & side do not match.'); cd(oldir); return; end;

id=find(~done,1,'first'); current=zeros(1,nph+1)-100; current(nph+1)=id; curt=clock;
set(head,'String',[code{id} [': pic '] num2str(id) '/' num2str(count)]);

a=fnames{id}; cd(pickf); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
%s=size(im); gap=300; im=imcrop(im,[gap   1.5*gap s(2)-2*gap s(1)-3*gap]);
axes(front); imshow(im);
a=fnamess{id}; cd(picks); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
%s=size(im); gap=300; im=imcrop(im,[gap/2 1.5*gap s(2)-gap  s(1)-3*gap]);
axes(side); imshow(im);
cd(oldir);


% --- Outputs from this function are returned to the command line.
function varargout = face_phenotyping_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function b1_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{1}); title('1. Head Shape');
function b2_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{2}); title('2. Forehead Bias');
function b3_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{3}); title('3. Brow Ridge');
function b4_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{4}); title('4. Mono-Brow');
function b5_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{5}); title('5. Eye Fold');
function b6_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{6}); title('6. Ear Protrusion');
function b7_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{7}); title('7. Nasal Root');
function b8_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{8}); title('8. Nose Bridge Breadth');
function b9_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{9}); title('9. Nose Wing Breadth');
function b10_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{10}); title('10. Nose Tip Shape');
function b11_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{11}); title('11. Nose Profile');
function b12_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{12}); title('12. Inclination of the Columella');
function b13_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{13}); title('13. Nose Protrusion');
function b14_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{14}); title('14. Orientation of Mouth Corner');
function b15_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{15}); title('15. Upper Vermillion (upper lip)');
function b16_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{16}); title('16. Lower Vermillion (lower lip)');
function b17_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{17}); title('17. Chin Shape');
function b18_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{18}); title('18. Chin Protrusion');
function b19_Callback(hObject, eventdata, handles)
global help img; axes(help); imshow(img{19}); title('19. Pronounciation of Cheek Bones');






function mark_Callback(hObject, eventdata, handles)
% hObject    handle to mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global main oldir pickf picks help front side head nph fnames fnamess done count code pheno current tstart tend times curt

axes(side); hold on; text(500,90,'Saving...','FontSize',30,'Color',[1 0 0]); hold off; pause(0.001);

a=get(handles.g1,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(1)=b-1; end;
a=get(handles.g2,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(2)=b-1; end;
a=get(handles.g3,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(3)=b-1; end;
a=get(handles.g4,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(4)=b-1; end;
a=get(handles.g5,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(5)=b-1; end;
a=get(handles.g6,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(6)=b-1; end;
a=get(handles.g7,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(7)=b-1; end;
a=get(handles.g8,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(8)=b-1; end;
a=get(handles.g9,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(9)=b-1; end;
a=get(handles.g10,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(10)=b-1; end;
a=get(handles.g11,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(11)=b-1; end;
a=get(handles.g12,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(12)=b-1; end;
a=get(handles.g13,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(13)=b-1; end;
a=get(handles.g14,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(14)=b-1; end;
a=get(handles.g15,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(15)=b-1; end;
a=get(handles.g16,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(16)=b-1; end;
a=get(handles.g17,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(17)=b-1; end;
a=get(handles.g18,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(18)=b-1; end;
a=get(handles.g19,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(19)=b-1; end;

set(handles.g1,'SelectedObject',[]);  set(handles.g2,'SelectedObject',[]);  set(handles.g3,'SelectedObject',[]);  set(handles.g4,'SelectedObject',[]);
set(handles.g5,'SelectedObject',[]);  set(handles.g6,'SelectedObject',[]);  set(handles.g7,'SelectedObject',[]);  set(handles.g8,'SelectedObject',[]);
set(handles.g9,'SelectedObject',[]);  set(handles.g10,'SelectedObject',[]); set(handles.g11,'SelectedObject',[]); set(handles.g12,'SelectedObject',[]);
set(handles.g13,'SelectedObject',[]); set(handles.g14,'SelectedObject',[]); set(handles.g15,'SelectedObject',[]); set(handles.g16,'SelectedObject',[]);
set(handles.g17,'SelectedObject',[]); set(handles.g18,'SelectedObject',[]); set(handles.g19,'SelectedObject',[]);

cd(oldir);
id=current(nph+1); pheno(id,:)=current(1:nph); done(id)=1;
tstart(id,:)=curt; tim=clock; tend(id,:)=tim; times(id)=etime(tim,curt);
save('worklist.mat','fnames','fnamess','done','count','code','pheno','tstart','tend','times');
n=sum(done);
dat=cell(n+1,nph+3);
dat(1,:)={'Code','Head Shape','Forehead Bias','Brow Ridge','Mono-Brow','Eye Fold','Ear Protrusion','Nasal Root','Nose Bridge Breadth','Nose Wing Breadth','Nose Tip Shape',...
    'Nose Profile','Columella Inclination','Nose Protrusion','Mouth Corner Orientation','Upper Lip','Lower Lip','Chin Shape','Chin Protrusion','Cheekbone Pronounciation',...
    'Duration (sec)','Completion Date'};
dat(2:end,1)=code(done); dat(2:end,2:nph+1)=num2cell(pheno(done,:)); dat(2:end,nph+2)=num2cell(times(done));
ttemp=tend(done,:); for tvar=2:(n+1), dat{tvar,nph+3}=datestr(ttemp(tvar-1,:)); end;
xlswrite('data_face.xlsx',dat); % delete('data_face.xls'); xlswrite('data_face.xls',dat);

if all(done), set(head,'String','All pictures processed.'); axes(front); cla; axes(side); cla; cd(oldir); return; end;

id=find(~done,1,'first'); current=zeros(1,nph+1)-100; current(nph+1)=id; curt=clock;
set(head,'String',[code{id} [': pic '] num2str(id) '/' num2str(count)]);

a=fnames{id}; cd(pickf); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
%s=size(im); gap=300; im=imcrop(im,[gap   1.5*gap s(2)-2*gap s(1)-3*gap]);
axes(front); imshow(im);
a=fnamess{id}; cd(picks); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
%s=size(im); gap=300; im=imcrop(im,[gap/2 1.5*gap s(2)-gap  s(1)-3*gap]);
axes(side); imshow(im);
cd(oldir);




% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global main oldir pickf picks help front side head nph fnames fnamess done count code pheno current tstart tend times curt

a=get(handles.g1,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(1)=b-1; end;
a=get(handles.g2,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(2)=b-1; end;
a=get(handles.g3,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(3)=b-1; end;
a=get(handles.g4,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(4)=b-1; end;
a=get(handles.g5,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(5)=b-1; end;
a=get(handles.g6,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(6)=b-1; end;
a=get(handles.g7,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(7)=b-1; end;
a=get(handles.g8,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(8)=b-1; end;
a=get(handles.g9,'SelectedObject');  if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(9)=b-1; end;
a=get(handles.g10,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(10)=b-1; end;
a=get(handles.g11,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(11)=b-1; end;
a=get(handles.g12,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(12)=b-1; end;
a=get(handles.g13,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(13)=b-1; end;
a=get(handles.g14,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(14)=b-1; end;
a=get(handles.g15,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(15)=b-1; end;
a=get(handles.g16,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(16)=b-1; end;
a=get(handles.g17,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(17)=b-1; end;
a=get(handles.g18,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(18)=b-1; end;
a=get(handles.g19,'SelectedObject'); if ~isempty(a), b=get(a,'Tag'); b=str2num(b(end));  current(19)=b-1; end;

id=current(nph+1);
if any(current<-1),
    errordlg(['Error: ' num2str(sum(current<-1)) ' variable(s) not provided yet!']);
else
    axes(side); hold on; text(500,90,'Saving...','FontSize',30,'Color',[1 0 0]); hold off; pause(0.001);
    set(handles.g1,'SelectedObject',[]);  set(handles.g2,'SelectedObject',[]);  set(handles.g3,'SelectedObject',[]);  set(handles.g4,'SelectedObject',[]);
    set(handles.g5,'SelectedObject',[]);  set(handles.g6,'SelectedObject',[]);  set(handles.g7,'SelectedObject',[]);  set(handles.g8,'SelectedObject',[]);
    set(handles.g9,'SelectedObject',[]);  set(handles.g10,'SelectedObject',[]); set(handles.g11,'SelectedObject',[]); set(handles.g12,'SelectedObject',[]);
    set(handles.g13,'SelectedObject',[]); set(handles.g14,'SelectedObject',[]); set(handles.g15,'SelectedObject',[]); set(handles.g16,'SelectedObject',[]);
    set(handles.g17,'SelectedObject',[]); set(handles.g18,'SelectedObject',[]); set(handles.g19,'SelectedObject',[]);
    
    cd(oldir);
    pheno(id,:)=current(1:nph); done(id)=1;
    tstart(id,:)=curt; tim=clock; tend(id,:)=tim; times(id)=etime(tim,curt);
    save('worklist.mat','fnames','fnamess','done','count','code','pheno','tstart','tend','times');
    n=sum(done);
    dat=cell(n+1,nph+3);
    dat(1,:)={'Code','Head Shape','Forehead Bias','Brow Ridge','Mono-Brow','Eye Fold','Ear Protrusion','Nasal Root','Nose Bridge Breadth','Nose Wing Breadth','Nose Tip Shape',...
        'Nose Profile','Columella Inclination','Nose Protrusion','Mouth Corner Orientation','Upper Lip','Lower Lip','Chin Shape','Chin Protrusion','Cheekbone Pronounciation',...
        'Duration (sec)','Completion Date'};
    dat(2:end,1)=code(done); dat(2:end,2:nph+1)=num2cell(pheno(done,:)); dat(2:end,nph+2)=num2cell(times(done));
    ttemp=tend(done,:); for tvar=2:(n+1), dat{tvar,nph+3}=datestr(ttemp(tvar-1,:)); end;
    xlswrite('data_face.xlsx',dat); % delete('data_face.xls'); xlswrite('data_face.xls',dat);
    
    if all(done), set(head,'String','All pictures processed.'); axes(front); cla; axes(side); cla; cd(oldir); return; end;

    id=find(~done,1,'first'); current=zeros(1,nph+1)-100; current(nph+1)=id; curt=clock;
    set(head,'String',[code{id} [': pic '] num2str(id) '/' num2str(count)]);

    a=fnames{id}; cd(pickf); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
    %s=size(im); gap=300; im=imcrop(im,[gap   1.5*gap s(2)-2*gap s(1)-3*gap]);
    axes(front); imshow(im);
    a=fnamess{id}; cd(picks); im=imread(a); s=size(im); if s(1)<s(2), im=imrotate(im,90); end;
    %s=size(im); gap=300; im=imcrop(im,[gap/2 1.5*gap s(2)-gap  s(1)-3*gap]);
    axes(side); imshow(im);
    cd(oldir);
end;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function names = listfiles(varargin)

if isempty(varargin), % current directory, list all files
    dr=cd; oldr=dr; filei=0; diri=0;
elseif length(varargin)==1, % either directory or file type
    tem=char(varargin{1});
    if strcmpi(tem,'dir'), dr=cd; oldr=dr; filei=0; diri=1; % list folders only, current directory
    elseif tem(1)=='.', dr=cd; oldr=dr; filei=1; diri=0; typ=tem; % list files typ, current directory
    elseif tem(2)==':', oldr=cd; dr=tem; filei=0; diri=0; % use input directory, all files
    else error('not a valid input');
    end
elseif length(varargin)==2, % both directory and file type
    tem1=char(varargin{1}); tem2=char(varargin{2}); oldr=cd;
    if tem1(2)==':', % then it is the folder
        dr=tem1; if dr(2)~=':', error('not a valid directory'); end;
        if tem2(1)=='.', filei=1; diri=0; typ=tem2; % list files typ
        elseif strcmpi(tem2,'dir'), filei=0; diri=1; % list folders only
        else error('not a valid file type');
        end
    else % then it is the file type
        dr=tem2; if dr(2)~=':', error('not a valid directory'); end;
        if tem1(1)=='.', filei=1; diri=0; typ=tem1; % list files typ
        elseif strcmpi(tem1,'dir'), filei=0; diri=1; % list folders only
        else error('not a valid file type');
        end
    end
else error('too many arguments');
end

cd(dr); a=dir; n=length(a);

names=cell(0); count=1;

%disp('******************************************************************');
if diri==1, % list folders
    for i=3:n, if a(i).isdir, names{count}=a(i).name; count=count+1; end; end;
else % list files
    if filei==0, % list all files, including folders
        for i=3:n, names{count}=a(i).name; count=count+1; end;
    else % list files of type typ
        k=length(typ);
        for i=3:n,
            tem=a(i).name; m=length(tem);
            if a(i).isdir==0&&m>k&&strcmpi(tem(m-k+1:m),typ), names{count}=tem(1:m-k);  count=count+1; end;
        end
    end
end
%disp('******************************************************************');

cd(oldr); names=names';
