%%% this directory is where i am going to build my analysis script in python

%%% my analysis script shall do the following

%%% load image1 mask
%%% read or assign cell IDs in image1 mask
%%% attain summed pixel values for cell ID 1 in image 1 (real image, not mask)
%%% iterate over all cell IDs in image 1
%%% iterate over all images in movie
%%% end up with table of cellID pixelvalues against image number

%%% possible points of difficulty include; ensuring continguous and consistent cellIDs, could maybe use the tracking files to fix this; the manipulation of TIFF files in python, might be easier than in matlab
