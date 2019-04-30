seg = imread('s_0.tif'); % open image
phase = imread('p_0.tif');
[L, n] = bwlabel(seg); %% label segments
pixel_data = regionprops(L, phase, 'PixelValues', 'MeanIntensity', 'Area')
for i=1:n
  cell_opd(i) = pixel_data(i).Area * pixel_data(i).MeanIntensity;
end %%% -----------for loop calculates the OPD for each cell i

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

%%%% --- MAKE LOOP TO LOAD ALL IMAGES

seg1 = imread('s_1.tif'); % open image
phase1 = imread('p_1.tif');
[L1, n1] = bwlabel(seg1); %% label segments
pixel_data_1 = regionprops(L1, phase1, 'PixelValues', 'MeanIntensity', 'Area')
for i=1:n1
  cell_opd_1(i) = pixel_data(i).Area * pixel_data(i).MeanIntensity;
end %%% -----------for loop calculates the OPD for each cell i

I1 = im2uint8(seg1);
I1(~seg1) = 200;
s1 = regionprops(L1, 'extrema');
imshow(I1, 'InitialMagnification', 'fit')
hold on
for k = 1:numel(s1)
   e = s(k).Extrema;
   text(e(1,1), e(1,2), sprintf('%d', k));
end
hold off

overlap = seg & seg1;
pairs = [L(overlap), L1(overlap)];
pairs = unique(pairs, 'rows'); %% pairs shows the index transformation

S = sparse(pairs(:,1), pairs(:,2), 1);
spy(S) %% adjacency graph
