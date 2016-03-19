%This script aims to streamline the process to produce large arrays of
%evenly spread points throughout simple geometries such as rectangles and
%circles. The motivation behind creating a script with said capabilities
%branches from the fact that, at the time of the creation of this script,
%conventional lower end CAM programs struggle to deal with a large number
%of points. This script was developed by Kevin Trevino while participating
%on a Senior Design Project aiming to study the effects of micro-bubbles
%for sound attenuation at the University of Illinois at Chicago, in the
%Mechanical Engineering Program.
clc;
close all;

%Request Information from User (details about plate, point distancess)
length = input('Please input length of plate, (x displacement total): ');
width  = input('Please input width of plate, (y displacement total): ');
x_edge = input('Please input distance from edge to the nearest row (x disp from plate to center of point): ');
y_edge = input('Please input distance from edge to the nearest column (y disp from plate to center of point): ');
depth = input('Please input depth of hole: ');
tool_d = input('Please input tool diameter: ');
tool_AR = input('Please input tool aspect ratio: ');
fileName = input('Please input the desired name of the file: ','s');

disp('Should the array be generated based on desired amount of points (CHOICE = 1)');
disp('Or based on the center-to-center distance between the points (CHOICE = 2)');
choice1 = input('Choice 1 or choice 2 from above description? ');

%distance between points initialization
x_step = 0;
y_step = 0;
x_pts = 0;
y_pts = 0;

if choice1>0 || choice1<3

switch choice1,
    case 1
        disp('You have chosen to define the distance between points based on desired amount of points.');
        %Request desired amount of points
        x_pts = input('Enter desired number of points in the x-axis (length-wise): ');
        y_pts = input('Enter desired number of points in the y-axis (width-wise); ');
        %Calculate distance between points
        x_step = (length-(2*x_edge))/x_pts;
        y_step = (width-(2*y_edge))/y_pts;
        
        if x_step < (2*tool_d) || y_step < (2*tool_d)   %Warns of tool being larger than maching distance
            choice2 = 1;
            
        else choice2 = 2;
        end;
        
        switch choice2
            case 1
                disp('Step is smaller than tool diameter.');
            case 2
                %Display step-sizes to be used on array generation
                disp(['Based on the desired ',num2str(x_pts),' on the x (horizontal) and ',num2str(y_pts),' on the y (vertical),']);
                disp('the calculated step-sizes are as follows: ');
                disp([num2str(x_step),' between points in the x direction']);
                disp([num2str(y_step),' between points in the y direction']);
                disp(['This is for a total of ', num2str(x_pts*y_pts), ' of points in the array.']);
        end;
            
    case 2
        disp('You have chosen to define the distace between the points directly.');
        %Request distance between points on each axis
        x_step = input('Enter desired step size between points in the x-axis: ');
        y_step = input('Enter desired step size between points in the y-axis: ');
        
        if x_step < (2*tool_d) || y_step < (2*tool_d)   %Warns of tool being larger than maching distance
            choice2 = 1;
            
        else choice2 = 2;
        end;
        
        switch choice2
            case 1
                disp('Step is smaller than tool diameter.');
            case 2
                %Calculate amount of points in each direction
                x_pts = floor((length-2*x_edge)/x_step);
                y_pts = floor((width-2*y_edge)/y_step);
                %Display amount of points in each direction along with total amount
                %of points
                disp(['Based on the entered ',num2str(x_step),' step size in the x and ',num2str(y_step),' step size in the y,']);
                disp('the amount of points on each direction is as follows: ');
                disp([num2str(x_pts),' points in the x direction']);
                disp([num2str(y_pts),' points in the y direction']);
                disp(['This is for a total of ', num2str(x_pts*y_pts), ' of points in the array.']);
        end;
end;
else 
    disp('The option you entered is not valid.');
end;

%Generate vectors for each increment in both directions
x_vector = (x_edge):x_step:(length-x_edge);
y_vector = (y_edge):y_step:(width-y_edge);

y_counter = 1;

M_xy = ones(x_pts*y_pts,2);


while y_counter <= y_pts+1,  
    
    x_counter = 1;
    
    while x_counter <= x_pts+1,
        M_xy(((y_counter-1)*(x_pts+1)+x_counter),1)= x_vector(x_counter);
        M_xy(((y_counter-1)*(x_pts+1)+x_counter),2)= y_vector(y_counter);
        x_counter = x_counter + 1;
    end;
    
    y_counter = y_counter + 1;
    
end

%disp(num2str(M_xy,'% -.7f'));

plot(M_xy(:,1),M_xy(:,2),'.');
axis([0 length 0 width])
disp(['Total number of elements: ',num2str(numel(M_xy))]);

N_counter = 1;
print_counter = 1;
fid = fopen([fileName,'.tap'],'wt');

fprintf(fid,['N',num2str(N_counter),' G00',' X0 ',' Y0 ',' Z0']);
fprintf(fid,'\n');
N_counter = N_counter +1;

fprintf(fid,['N',num2str(N_counter),' G00',' X0 ',' Y0 ',' Z',num2str(3*depth)]);
fprintf(fid,'\n');
N_counter = N_counter +1;

while print_counter<=(x_pts*y_pts)
    %get to location quickly, hence the G00 (rapid tool positioning)
    %disp(['N',num2str(print_counter),' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z0']);
    fprintf(fid,['N',num2str(N_counter),' G00',' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z',num2str(3*depth)]);
    fprintf(fid,'\n');
    N_counter = N_counter +1;
    %begin simulated "peck drilling"
    
    %GO DOWN HALF THE DESIRED DEPTH
    fprintf(fid,['N',num2str(N_counter),' G00',' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z','-',num2str(depth/2,'%-.5f')]);
    fprintf(fid,'\n');
    N_counter = N_counter +1;
    %GO UP TO TOP POSITION one depth unit above the origin plane XY
    fprintf(fid,['N',num2str(N_counter),' G01',' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z',num2str(depth)]);
    fprintf(fid,'\n');
    N_counter = N_counter +1;
    %GO DOWN THE FULL DEPTH
    fprintf(fid,['N',num2str(N_counter),' G01',' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z','-',num2str(depth,'%-.5f')]);
    fprintf(fid,'\n');
    N_counter = N_counter +1;
    %GO UP TO TOP POSITION three depth units above the origin plane XY
    fprintf(fid,['N',num2str(N_counter),' G00',' X',num2str(M_xy(print_counter,1),'%-.7f'),' Y',num2str(M_xy(print_counter,2),'%-.5f'),' Z',num2str(3*depth)]);
    fprintf(fid,'\n');
    N_counter = N_counter +1;
    
    print_counter = print_counter+1;
end;

%Go back to origin
fprintf(fid,['N',num2str(N_counter),' G00',' X0 ',' Y0 ',' Z',num2str(20*depth)]);
fprintf(fid,'\n');
N_counter = N_counter +1;

fclose(fid);