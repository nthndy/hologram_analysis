%%%% TESTING TO SEE WHY FOR LOOP OVER FRAMES DOESNT WORK

%%%  for f=257:703;
      %%% now that we have list of frames, we can load said images
      shifted_f = f - 1; %% file naming convention begins on 0, not 1
      file_number=num2str(shifted_f);
      seg_file_name=strcat('s_',file_number,'.tif');
      phase_file_name=strcat('p_',file_number,'.tif');
      seg = imread(seg_file_name); % open image
      phase = imread(phase_file_name);
          reassign_f = f - 256
          %%%%%%take coordinate of cell 5520, use matlab to label whole seg image, take new label from%%%%
          x1 = x_value(reassign_f); %% x and y coord of cell 5520 in frame 1 %%%
          y1 = y_value(reassign_f); %%% ISSUE HERE --> frame f < 448
          [L, n] = bwlabel(seg); %% pseudo label segments
          pseudo_label = L(x1,y1);

    pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area'); % append OPD column
    single_cell_pixel_data = pixel_data(pseudo_label);
    opd_value = single_cell_pixel_data.Area * single_cell_pixel_data.MeanIntensity;
    opd = [opd, opd_value];
    area = [area, single_cell_pixel_data.Area];
%%  end;
