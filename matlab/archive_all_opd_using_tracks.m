%%% load tracks_type1.mat file with tracks variable in
load('tracks_type1.mat')                  %%% have to make sure HDF folder is in path

results = [];                             %%% clean slate for new dataset

max_cell_ID = max(tracks(:,4));           %%% for iterating through cell_ID
min_cell_ID = min(tracks(:,4));

for cell_ID=min_cell_ID:max_cell_ID;      %%% 1st iteration through cell_ID

x_value = [];
y_value = [];
frame_num = [];

maxA=length(tracks);                      %%% a is the number of indices/data points in the tracking file (120753 for all cells)

  for a=1:maxA;                                   %%% 2nd iteration through all a for cell_ID
    if tracks(a,4) == cell_ID;                    %%% selecting all a for cell_ID
      frame_num = [frame_num, tracks(a,3)];       %%% selecting corresponding frame numbers for selected a
      x_value = [x_value, uint16(tracks(a,1))];
      y_value = [y_value, uint16(tracks(a,2))];   %%% select xy coordinates for selected a
    end;
  end;

%%% currently have a list of frame numbers and xy coordinates for cell_ID

opd = [];
area =[];
frame_index = 0;
frame_num_index = 0;
cell_ID_final = cell_ID + 1;                       %%% cell_ID has to be finally reformatted for storage in results

for f = frame_num;                                %%% 3rd iteration to load all images with selected frame number
      frame_index = frame_index + 1;              %%% counting the index of the frame number to use in coordiante retrieval
      frame_num_index = f + 1;
      shifted_f = num2str(f,'%03.f');                       %%% image file naming conventions, appends zeroes before f
      file_number_phase = shifted_f;
      file_number_seg = num2str(f);
      seg_file_name = strcat('s_',file_number_seg,'.tif');          %%% N.B. to self, this will have to change, both path wise and name wise
      phase_file_name = strcat('p_0',file_number_phase,'.tif');
      seg = imread(seg_file_name);                            %%% open images
      phase = imread(phase_file_name);
          xi = x_value(frame_index) + 1;                      %%% xy coord of cell_ID in frame f %%%
          yi = y_value(frame_index) + 1;                      %%% +1 because there seemed to be a rounding error that placed some coordinates outside of small cells (cells too small, likely errors)
          [L, n] = bwlabel(seg);                              %%% pseudo label segmented image
          pseudo_label = L(yi,xi);                            %%% coord switch for matrix data point retrieval, get the pseudolabel for cell_ID based on x1y1 coordinate value in pseudo image L, psuedo b/c it changes each iteration

%%%%%%%%%% put an else statement in here to record a 0 value for opd if pseudo_label = 0

          pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area'); % append OPD column to eliminate below line
                                                              %%% append OPD column, then can loop over all cells and have a new pixel data array for each cell, the trouble with this is that the matlab assigned cellIDs will change
          single_cell_pixel_data = pixel_data(pseudo_label);
          opd_value = single_cell_pixel_data.Area * single_cell_pixel_data.MeanIntensity;
          opd = [opd, opd_value];
          area = [area, single_cell_pixel_data.Area]; %%tidy up these calculations

          results.opd(cell_ID_final,frame_num_index) = opd_value;
          results.area(cell_ID_final,frame_num_index) = single_cell_pixel_data.Area;


end;

end;
