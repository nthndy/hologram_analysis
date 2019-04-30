maxA=length(tracks); %%%a is the number of indices/data points in the tracking file (120753 for cell 5520)

x_value = [];
y_value = [];
frame_num = [];

for a=1:maxA;
  frame_num = [frame_num, tracks(a,3)];
end

initial_frame = frame_num(1);
last_frame = max(frame_num);

opd = [];
area =[];
for f=initial_frame:last_frame;
      shifted_f = f - 1; %% image file naming convention begins on 0, not 1
      file_number=num2str(shifted_f);
      seg_file_name=strcat('s_',file_number,'.tif'); %%% this will have to change, both path wise and name wise
      phase_file_name=strcat('p_0',file_number,'.tif');
      seg = imread(seg_file_name); % open image
      phase = imread(phase_file_name);
          reassign_f = f - initial_frame +1; %%% because the cooridnates are stored as initial frame = 1, we need to reassign but ensure it continues to count up through iterations
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
    area = [area, single_cell_pixel_data.Area];
  end;
results.opd = opd;
results.area = area;
