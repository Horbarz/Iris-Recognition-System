%function [fOut] = segmentTest(img)
cd('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\test_iris\')
[FileName,PathName] = uigetfile('*.bmp;*.jpg;','Select the iris to use');

[rgbImage, colorMap] = imread(FileName);
% Get the dimensions of the image. numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
disp([numberOfColorBands])
% If it's an indexed image (such as Kids), turn it into an rgbImage;
if numberOfColorBands > 1
rgbImage = ind2rgb(rgbImage, colorMap); % Will be in the 0-1 range.
rgbImage = uint8(255*rgbImage); % Convert to the 0-255 range.
end

%Located iris and pupil
[imageLocated,xc,yc,time]= localisation2(rgbImage,0.2);
%segment iris and pupil
[ci,cp,out,time] = thresh(imageLocated,50,200);
%imshow(out);
[ring,fOut]=normaliseiris(imageLocated,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',100,300);


%imshow(fOut);
% Display the original color image full screen
% imshow(rgbImage);
% title('Double-click inside box to finish box', 'FontSize', fontSize);
% % Enlarge figure to full screen.
% set(gcf, 'units','normalized','outerposition', [0 0 1 1]);
% % Have user specify the area they want to define as neutral colored (white or gray).
% promptMessage = sprintf('Drag out a box over the ROI you want to be neutral colored.\nDouble-click inside of it to finish it.');
% titleBarCaption = 'Continue?';
% button = questdlg(promptMessage, titleBarCaption, 'Draw', 'Cancel', 'Draw');
% if strcmpi(button, 'Cancel')
% return;
% end
% hBox = imrect;
% roiPosition = wait(hBox); % Wait for user to double-click
% roiPosition % Display in command window.
% % Get box coordinates so we can crop a portion out of the full sized image.
% xCoords = [roiPosition(1), roiPosition(1)+roiPosition(3), roiPosition(1)+roiPosition(3), roiPosition(1), roiPosition(1)];
% yCoords = [roiPosition(2), roiPosition(2), roiPosition(2)+roiPosition(4), roiPosition(2)+roiPosition(4), roiPosition(2)];
% croppingRectangle = roiPosition;
% Display (shrink) the original color image in the upper left.
subplot(2, 4, 1);
imshow(rgbImage);
title('Original Color Image', 'FontSize', fontSize);
% Crop out the ROI.
whitePortion = fOut;
% [iris,pupil,noise] = segmentiris(rgbImage);
subplot(2, 4, 5);
imshow(whitePortion);
 % caption = sprintf('ROI\nDefined to be "White"');
% title(caption, 'FontSize', fontSize);
% Extract the individual red, green, and blue color channels.
redChannel = whitePortion(:, :, 1);
greenChannel = whitePortion(:, :, 2);
blueChannel = whitePortion(:, :, 3);
% Display the color channels.
subplot(2, 4, 2);
imshow(redChannel);
title('Red Channel ROI', 'FontSize', fontSize);
subplot(2, 4, 3);
imshow(greenChannel);
title('Green Channel ROI', 'FontSize', fontSize);
subplot(2, 4, 4);
imshow(blueChannel);
title('Blue Channel ROI', 'FontSize', fontSize);
% Get the means of each color channel
meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
% Let's compute and display the histograms.
[pixelCount grayLevels] = imhist(redChannel);
subplot(2, 4, 6); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Original Red ROI\nMean Red = %.1f', meanR);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Let's compute and display the histograms.
[pixelCount grayLevels] = imhist(greenChannel);
subplot(2, 4, 7); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Original Green ROI\nMean Green = %.1f', meanG);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Let's compute and display the histograms.
[pixelCount grayLevels] = imhist(blueChannel);
subplot(2, 4, 8); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Original Blue ROI.\nMean Blue = %.1f', meanB);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% specify the desired mean.
desiredMean = mean([meanR, meanG, meanB])
message = sprintf('Red mean = %.1f\nGreen mean = %.1f\nBlue mean = %.1f\nAssumed Means %.1f',...
meanR, meanG, meanB, desiredMean);
uiwait(helpdlg(message));

%---------------------------------------Correction Panel------------------------------
% Linearly scale the image in the cropped ROI.
correctionFactorR = desiredMean / meanR;
correctionFactorG = desiredMean / meanG;
correctionFactorB = desiredMean / meanB;
redChannel = uint8(single(redChannel) * correctionFactorR);
greenChannel = uint8(single(greenChannel) * correctionFactorG);
blueChannel = uint8(single(blueChannel) * correctionFactorB);
% Recombine into an RGB image
% Recombine separate color channels into a single, true color RGB image.
correctedRgbImage = cat(3, redChannel, greenChannel, blueChannel);
figure;
% Display the original color image.
subplot(2, 4, 5);
imshow(correctedRgbImage);
title('Color-Corrected ROI', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Display the color channels.
subplot(2, 4, 2);
imshow(redChannel);
title('Corrected Red ROI', 'FontSize', fontSize);
subplot(2, 4, 3);
imshow(greenChannel);
title('Corrected Green ROI', 'FontSize', fontSize);
subplot(2, 4, 4);
imshow(blueChannel);
title('Corrected Blue ROI', 'FontSize', fontSize);
% Get the means of the corrected ROI for each color channel.
meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
correctedMean = mean([meanR, meanG, meanB])
% Let's compute and display the histograms of the corrected image.
[pixelCount grayLevels] = imhist(redChannel);
p1 = subplot(2, 4, 6); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Corrected Red ROI.\nMean Red = %.1f', meanR);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Let's compute and display the histograms.
[pixelCount grayLevels] = imhist(greenChannel);
p2 = subplot(2, 4, 7); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Corrected Green ROI.\nMean Green = %.1f', meanG);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Let's compute and display the histograms.
[pixelCount grayLevels] = imhist(blueChannel);
p3 = subplot(2, 4, 8); 
bar(pixelCount);
grid on;
caption = sprintf('Hist Corrected Blue ROI.\nMean Blue = %.1f', meanB);
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
message = sprintf('Now, the\nCorrected Red mean = %.1f\nCorrected Green mean = %.1f\nCorrected Blue mean = %.1f\n(Differences are due to clipping.)\nWe now apply it to the whole image',...
meanR, meanG, meanB);
uiwait(helpdlg(message));
%----------------------------------------------------------------------------------------------------------

% Now correct the original image.
% Extract the individual red, green, and blue color channels.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
% Linearly scale the full-sized color channel images
redChannelC = uint8(single(redChannel) * correctionFactorR);
greenChannelC = uint8(single(greenChannel) * correctionFactorG);
blueChannelC = uint8(single(blueChannel) * correctionFactorB);
% Recombine separate color channels into a single, true color RGB image.
correctedRGBImage = cat(3, redChannelC, greenChannelC, blueChannelC);
subplot(2, 4, 1);
imshow(correctedRGBImage);
title('Corrected Full-size Image', 'FontSize', fontSize);

%---------------------------------Contrast Enhancement algorithm-----------

% compute retinex algorithm--> red.
cla(p1)
%redChannelG = imgaussfilt(redChannelC,2);
%image enhancement algorithm
L = max(redChannelC,[],3);
%computing of reflectance
redChannelret = MSRetinex(mat2gray(L),5,3,2,[5,5],8);
redChannelret2 = MSRetinex2(mat2gray(L),[5,35,150],[5 5],8);
%use value of hsv domain
% Ihsv = rgb2hsv(redChannelC);
% Ihsv(:, :, 3) = mat2gray(ret);
% R1 = hsv2rgb(Ihsv);
% Ihsv(:, :, 3) = mat2gray(ret2);
% R2 = hsv2rgb(Ihsv);

%im_RedHist = histeq(redChannelret);
[pixelCount grayLevels] = imhist(redChannelret);
subplot(2, 4, 6); 
bar(pixelCount);
grid on;
caption = sprintf('Enhcd Red Hist');
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% compute enhanced histogram--> green.
cla(p2)
greenChannelG =imgaussfilt(greenChannelC,2); 
im_GreenHist = histeq(greenChannelG);
[pixelCount grayLevels] = imhist(im_GreenHist);
subplot(2, 4, 7); 
bar(pixelCount);
grid on;
caption = sprintf('Green ROI');
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% compute enhanced histogram--> blue.
cla(p3)
blueChannelG = imgaussfilt(blueChannelC,2);
im_BlueHist = histeq(blueChannelG);
[pixelCount grayLevels] = imhist(im_BlueHist);
subplot(2, 4, 8); 
bar(pixelCount);
grid on;
caption = sprintf('Blue ROI');
title(caption, 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
message = sprintf('Done with the demo.\nPlease flicker between the two figures');
uiwait(helpdlg(message));

figure;
subplot(2, 1, 1)
imshowpair(redChannelC, redChannelret, 'montage')
title('Red Filtered Output')



%end


