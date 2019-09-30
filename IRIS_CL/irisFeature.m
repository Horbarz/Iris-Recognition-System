% path for writing diagnostic images
clc;close all; clear all;
w = cd;
% [FileName PathName] = uigetfile('.jpg');
% ip = PathName;
disp('Performs Feature Extraction and Encoding of the iris')
%irispro = input('Supply number of iris to process: ');
global DIAGPATH
%DIAGPATH = 'diagnostics';

%for irispro = 18
irispro = 18;
PathName = strcat('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\',num2str(irispro),'\');
disp(['Processing ','C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\',num2str(irispro)])
DIAGPATH = PathName;

%for ie = 11:15
    ie = 11;
    eyeimage_filename = strcat(PathName,num2str(ie),'.jpg');
    
%normalisation parameters
radial_res = 20;
angular_res = 2410100;
% with these settings a 9600 bit iris template is
% created

%feature encoding parameters
nscales=1;
minWaveLength=18;
mult=1; % not applicable if using nscales = 1
sigmaOnf=0.5;

cd(PathName)
eyeimg = imread(eyeimage_filename); 
eyeimage = rgb2gray(eyeimg);


savefile = [eyeimage_filename,'-houghpara.mat'];
[stat,mess]=fileattrib(savefile);

if stat == 1
    % if this file has been processed before
    % then load the circle parameters and
    % noise information for that file.
    disp(['Am in the if statement'])
    load(savefile);
else
    
    % if this file has not been processed before
    % then perform automatic segmentation and
    % save the results to a file
    cd(w);
    [circleiris circlepupil imagewithnoise] = segmentiris(eyeimage);
    %save(savefile,'circleiris','circlepupil','imagewithnoise');
end

% WRITE NOISE IMAGE
%

imagewithnoise2 = uint8(imagewithnoise);
imagewithcircles = uint8(eyeimage);

%get pixel coords for circle around iris
[x,y] = circlecoords([circleiris(2),circleiris(1)],circleiris(3),size(eyeimage));
ind2 = sub2ind(size(eyeimage),double(y),double(x)); 

%get pixel coords for circle around pupil
[xp,yp] = circlecoords([circlepupil(2),circlepupil(1)],circlepupil(3),size(eyeimage));
ind1 = sub2ind(size(eyeimage),double(yp),double(xp));


% Write noise regions
imagewithnoise2(ind2) = 255;
imagewithnoise2(ind1) = 255;
% Write circles overlayed
imagewithcircles(ind2) = 255;
imagewithcircles(ind1) = 255;
% w = cd;
% cd(DIAGPATH);
% imwrite(imagewithnoise2,[eyeimage_filename,'-noise.jpg'],'jpg');
% imwrite(imagewithcircles,[eyeimage_filename,'-segmented.jpg'],'jpg');
% cd(w);

% perform normalisation

[polar_array, noise_array] = normaliseiris(imagewithnoise, circleiris(2),...
    circleiris(1), circleiris(3), circlepupil(2), circlepupil(1), circlepupil(3),eyeimage_filename, radial_res, angular_res);


% WRITE NORMALISED PATTERN, AND NOISE PATTERN
% w = cd;
% cd(DIAGPATH);
% imwrite(polar_array,[eyeimage_filename,'-polar.jpg'],'jpg');
% imwrite(noise_array,[eyeimage_filename,'-polarnoise.jpg'],'jpg');
% cd(w);

% perform feature encoding
[template, mask] = encode(polar_array, noise_array, nscales, minWaveLength, mult, sigmaOnf);

cd(PathName)
imwrite(template,strcat('e',num2str(ie),'.jpg'),"jpg")
imwrite(mask,strcat('e',num2str(ie),'.jpg'),"jpg")
disp(strcat(eyeimage_filename,' is processed'))
cd(w)
%end

%end

y = input('Do you want to repeat:[y/n]','s');
switch y
    case 'y'
        irisFeature
    case 'n'
        return
end