%The purpose of this script is to allow users of a micro milling machine to
%quickly generate G-code to clear the top layer of the part to be machined
%in order to ensure the plane of top layer of the part to be machined
%parallel to the x and y plane of machining.-

clc;
close all;

fileName = input('Please input the desired name of the file: ','s');
length = input('Please input length of plate, (x displacement total): ');
width  = input('Please input width of plate, (y displacement total): ');
depth_flat = input('Please input depth of hole: ');     %depth of top layer to be removed
tool_d_flat = input('Please input tool diameter: ');    %diameter of tool for top layer removal

Num_passes = (ceil(width/(tool_d_flat/2))+2);

disp(Num_passes);

matrix_size = Num_passes*2;

M_clean = ones(matrix_size,2);

counter_h = 1;

while counter_h <= matrix_size
    
    M_clean(counter_h,1) = 0;
    
    counter_h = 1 + counter_h;
    
    M_clean(counter_h,1) = length;
    
    counter_h = 1 + counter_h;
    
    M_clean(counter_h,1) = length;
    
    counter_h = 1 + counter_h;
    
    M_clean(counter_h,1) = 0;
    
    counter_h = 1 + counter_h;
    
end;

counter_v = 1;
counter_loop = 1;

v_pos = 0;

while counter_v <= matrix_size
    
    M_clean(counter_v,2) = v_pos;
    
    counter_v = 1 + counter_v;
    
    M_clean(counter_v,2) = v_pos;
    
    counter_v = 1 + counter_v;
    
    v_pos = v_pos + (tool_d_flat/2);

end;

disp(num2str(M_clean));

%plot(M_clean(:,1),M_clean(:,2),'r');

N_counter = 1;
%print_counter = 1;
fid = fopen([fileName,'.tap'],'wt');

fprintf(fid,['N',num2str(N_counter),' G00 ','X',num2str(M_clean(N_counter,1),'%-.7f'),' Y',num2str(M_clean(N_counter,2),'%-.7f'),' Z','0']);
    fprintf(fid,'\n');
    N_counter = 1 + N_counter;
    
fprintf(fid,['N',num2str(N_counter),' G00 ','X',num2str(M_clean(N_counter,1),'%-.7f'),' Y',num2str(M_clean(N_counter,2),'%-.7f'),' Z-',num2str(depth_flat,'%-.7f')]);
    fprintf(fid,'\n');
    N_counter = 1 + N_counter;

while N_counter <= matrix_size
    
    fprintf(fid,['N',num2str(N_counter),' G00 ','X',num2str(M_clean(N_counter,1),'%-.7f'),' Y',num2str(M_clean(N_counter,2),'%-.7f'),' Z-',num2str(depth_flat,'%-.7f')]);
    fprintf(fid,'\n');
    N_counter = 1 + N_counter;
    
    
    
end;

fclose(fid);

plot(M_clean(:,1),M_clean(:,2));