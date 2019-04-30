%%% load tracks_type1.mat file with tracks variable in

load('tracks_type1.mat') %%% have to make sure HDF folder is in path

%%% list of frames for cell 5520
maxA=length(tracks); %%%a is the number of indices/data points in the tracking file (120753 for cell 5520)

x_value = [];
y_value = [];
frame_num = [];

cell_ID = input('Cell ID? Just type and enter ** cell ID 5520 was working as a test. INPUT ID:');
for a=1:maxA; %a is the number of data points with the cell_ID in
  if tracks(a,4) == cell_ID; %%% selecting the cell_ID from the column
    frame_num = [frame_num, tracks(a,3)]; %lists all frame numbers that cell_ID is in
    x_value = [x_value, uint16(tracks(a,1))];
    y_value = [y_value, uint16(tracks(a,2))]; %collects the coordinates
  end;
end;

initial_frame = frame_num(1);
last_frame = max(frame_num); %%%  ISSUE IS HERE!!!!down three rows
opd = [];
area =[];
for f=frame_num
%%for f=initial_frame:last_frame; %this makes the iteration go through step by step, not missing any frames like the actual video may, link to  frame_num
      shifted_f = f - 1; %% image file naming convention begins on 0, not 1
      file_number=num2str(shifted_f);
      seg_file_name=strcat('s_',file_number,'.tif'); %%% this will have to change, both path wise and name wise
      phase_file_name=strcat('p_0',file_number,'.tif');
      seg = imread(seg_file_name); % open image
      phase = imread(phase_file_name);
          reassign_f = f ; %%% because the cooridnates are stored as initial frame = 1, we need to reassign but ensure it continues to COUNT up through iterations
          %%%%%%take coordinate of cell 5520, use matlab to label whole seg image, take new label from%%%%
          x1 = x_value(reassign_f); %% x and y coord of cell 5520 in frame f %%%
          y1 = y_value(reassign_f);
          [L, n] = bwlabel(seg); %% pseudo label segments
          pseudo_label = L(x1,y1); %% get 'n', the label, for x1y1, psuedo bc it changes each iteration

    pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area'); % append OPD column to eliminate below line
%%% append OPD column, then can loop over all cells and have a new pixel data array for each cell, the trouble with this is that the matlab assigned cellIDs will change


    single_cell_pixel_data = pixel_data(pseudo_label);
    opd_value = single_cell_pixel_data.Area * single_cell_pixel_data.MeanIntensity;
    opd = [opd, opd_value];
    area = [area, single_cell_pixel_data.Area]; %%tidy up these calculations
  end;
results.opd(cell_ID,:) = opd;
results.area(cell_ID,:) = area;
