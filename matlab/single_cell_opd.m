%%%function to iterate over frames and measure cell opd,currently overwrites each frame cell OPD with the next

for f=0:4
  file_number=num2str(f);
  seg_file_name=strcat('s_',file_number,'.tif');
  phase_file_name=strcat('p_',file_number,'.tif');
  seg = imread(seg_file_name); % open image
  phase = imread(phase_file_name);
  [L, n] = bwlabel(seg); %% label segments
  pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area') % append OPD column
  %    for i=1:n
       cell_opd(i) = pixel_data(i).Area * pixel_data(i).MeanIntensity;
%%% THIS INCORRECTLY INPUTS CELL OPD I
    end
   % all_data(f).pixel_data = pixel_data;
   cell_opd_t = cell_opd.'

all_data(f+1).pixel_data = pixel_data
all_data(f+1).cell_opd = cell_opd_t
end

%%% function to calculate adjacency ie cell ID swaps
f=0;
for f=0:40
  file_number=num2str(f);
  seg_file_name=strcat('s_',file_number,'.tif');
  phase_file_name=strcat('p_',file_number,'.tif');
  cell_opd_file_name=strcat('cell_opd_frame_',file_number);
  seg = imread(seg_file_name); % open image
  phase = imread(phase_file_name);
  [L, n] = bwlabel(seg); %% label segments
  pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area');
      for k=1:n
        cell_opd(k) = pixel_data(k).Area * pixel_data(k).MeanIntensity;
   end

   I = im2uint8(seg);
I(~seg) = 200;
s = regionprops(L, 'extrema');
imshow(I, 'InitialMagnification', 'fit')
hold on
for k = 1:numel(s)
   e = s(k).Extrema;
   text(e(1,1), e(1,2), sprintf('%d', k));
end
hold off
file_name = strcat(file_number,'.png')
saveas(gcf,file_name)  %%% WARNING -- SAVES LABELLED FILES AS OUTPUT

f=f+1;

  file_number=num2str(f);
  seg_file_name=strcat('s_',file_number,'.tif');
  phase_file_name=strcat('p_',file_number,'.tif');
  cell_opd_file_name=strcat('cell_opd_frame_',file_number);
  seg1 = imread(seg_file_name); % open image
  phase1 = imread(phase_file_name);
  [L1, n1] = bwlabel(seg1); %% label segments
  pixel_data_1 = regionprops(L1, phase1, 'PixelValues', 'MeanIntensity', 'Area');
      for k=1:n
        cell_opd_1(k) = pixel_data(k).Area * pixel_data(k).MeanIntensity;
   end

I1 = im2uint8(seg1);
I1(~seg1) = 200;
s1 = regionprops(L1, 'extrema');
imshow(I1, 'InitialMagnification', 'fit')
hold on
for j = 1:numel(s1)
   e = s1(j).Extrema;
   text(e(1,1), e(1,2), sprintf('%d', k));
end
hold off
end

overlap = seg & seg1;
pairs = [L(overlap), L1(overlap)];
pairs = unique(pairs, 'rows'); %% pairs shows the index transformation

S = sparse(pairs(:,1), pairs(:,2), 1);
spy(S) %% adjacency graph

%%% function to save two sequential labelled images, need to run after above

 I = im2uint8(seg);
I(~seg) = 200;
s = regionprops(L, 'extrema');
imshow(I, 'InitialMagnification', 'fit')
hold on
for k = 1:numel(s)
   e = s(k).Extrema;
   text(e(1,1), e(1,2), sprintf('%d', k));
end
hold off

file_name = strcat(file_number,'.png')
saveas(gcf,file_name)

I1 = im2uint8(seg1);
I1(~seg1) = 200;
s1 = regionprops(L1, 'extrema');
imshow(I1, 'InitialMagnification', 'fit')
hold on
for j = 1:numel(s1)
   e = s1(j).Extrema;
   text(e(1,1), e(1,2), sprintf('%d', k));
end
hold off
