seg = imread('s_0.tif');
L = bwlabel(seg);


for f=0:40 %% 40images in this example
  file_number=num2str(f); %% numbering the file names
  seg_file_name=strcat('s_',file_number,'.tif'); %creating the file names so that they can be iteratively loaded
  phase_file_name=strcat('p_',file_number,'.tif');
  seg = imread(seg_file_name); % open image
  phase = imread(phase_file_name);% opening other image
  [L, n] = bwlabel(seg); %% label segments
  pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area')
    for i=1:n
        cell_opd(i) = pixel_data(i).Area * pixel_data(i).MeanIntensity;
    end
%% HERE I WANT A MATRIX THAT IS CELL_OPD WITH COLUMNS AS I AND ROWS AS F, SO KEEP ADDING CELL_OPD TO A NEW ROW OF MATRIX CELL_OPD
end
