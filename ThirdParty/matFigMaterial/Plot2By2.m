function Plot2By2(varargin)

% function Plot2By2(varargin)
%
% Shell function for plotting a figure with four sets of axes
% arranged as a 2 by 2 grid 
% Consider altering the lines marked: ***
%
% INPUT
% optional: filename - name and location to export .eps file of
%           figure. Should not include the extension "eps".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Settings

% Fonts
FontName = 'Times';
FSsm = 7;
FSmed = 10;
FSlg = 11;

% Line widths
LWthick = 2;
LWthin = 1;

% Colors
col1 = [0,0,0];
col2 = [1,0,0];
col3 = [0,0,1];
col4 = [1,3/4,0];
col5 = [0,1,3/4];
col6 = [3/4,0,1];
col7 = [3/4,1,0];
col8 = [0,3/4,1];
col9 = [1,0,3/4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set figure size
figure1 = figure;

PP = [0,0,14,10]; % *** paper position in centimeters
PS = PP(end-1:end); % paper size in centimeters

set(figure1,'paperpositionmode','manual','paperposition', ...
        PP,'papersize',PS, 'paperunits','centimeters');

if length(varargin)>0
  % So the figure is the same size on the screen as when it is printed:
  pu = get(gcf,'PaperUnits');
  pp = get(gcf,'PaperPosition');
  set(gcf,'Units',pu,'Position',pp)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Axis position

left = 0.1; % space on LHS of figure
right = 0.02; % space on RHS of figure
top = 0.05; % space above figure
bottom = 0.1;% space below figure
vspace = 0.1;
hspace = 0.1;

height = (1-top-bottom-vspace)/2; % height of axis
width = (1-left-right-hspace)/2; % width of axis

down = -[0,vspace+height,0,0];
across = [width+hspace,0,0,0];
pos11 = [left,1-top-height,width,height]; % position of axis
pos21 = pos11+down;
pos12 = pos11+across;
pos22 = pos21+across;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting

% First axis
ax11 = axes('position',pos11); % produce axis
hold on
ylabel('ylabel','fontname',FontName,'FontSize',FSmed) % add axis labels
xlabel('xlabel','fontname',FontName,'FontSize',FSmed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *** Place your plots for the first axis here




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		       
% Second axis
ax21 = axes('position',pos21); % produce second axis
hold on
ylabel('ylabel','fontname',FontName,'FontSize',FSmed) % add axis labels
xlabel('xlabel','fontname',FontName,'FontSize',FSmed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *** Place your plots for the second axis here




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		       
% Third axis
ax12 = axes('position',pos12); % produce third axis
hold on
ylabel('ylabel','fontname',FontName,'FontSize',FSmed) % add axis labels
xlabel('xlabel','fontname',FontName,'FontSize',FSmed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *** Place your plots for the third axis here




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		       
% Fourth axis
ax22 = axes('position',pos22); % produce fourth axis
hold on
ylabel('ylabel','fontname',FontName,'FontSize',FSmed) % add axis labels
xlabel('xlabel','fontname',FontName,'FontSize',FSmed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *** Place your plots for the fourth axis here





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tweaking axis to make them look nice

% First axis
set(ax11,'TickDir','out'); % alter the direction of the tick marks
set(ax11,'FontName',FontName,'FontSize',FSsm) % set the font name
                                             % and size
set(ax11,'box','off') % turns the figure bounding box off
set(ax11,'layer','top') % stops problems with lines being plotted on
                       % top of the axis lines

% Same for second axis		   
set(ax21,'TickDir','out'); 
set(ax21,'FontName',FontName,'FontSize',FSsm) 
set(ax21,'box','off') 
set(ax21,'layer','top')

% Same for third axis		   
set(ax12,'TickDir','out'); 
set(ax12,'FontName',FontName,'FontSize',FSsm)
set(ax12,'box','off') 
set(ax12,'layer','top')

% Same for fourth axis		   
set(ax22,'TickDir','out'); 
set(ax22,'FontName',FontName,'FontSize',FSsm)
set(ax22,'box','off') 
set(ax22,'layer','top')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exporting

if length(varargin)>0 % if the user supplies a file name...
  filename=[varargin{1},'.eps'];
  % choose the painters renderer, without cropping
  print(figure1,'-depsc','-painters',filename,'-loose');
  
  % open the eps in ghostview
  str = ['! gv ',filename,'&'];
  eval(str)
end
