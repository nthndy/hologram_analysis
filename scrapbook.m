% use morphological opening to estimate the background, strel used to create a flat structuring element with r the radius (larger r, smoother background)
background40 = imopen(I,strel('disk',40));
% Display the Background Approximation as a Surface
figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';
% subtract the background image and increase the contrast
I240 = I40 - background;
imshow(I240)
I340 = imadjust(I240);
imshow(I340);
% threshold the image, bwareaopen eliminates objects <10 pixels from binary image (can have connectivity variable)
bw40 = imbinarize(I340);
imshow(bw40)
