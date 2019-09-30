close all;
clear all;clc;
PathName = 'C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\right_iris\';

for iris = 20:30;
    for iris1 = 1:6;
    img_filename = strcat(PathName,num2str(iris),'RI_',num2str(iris1),'.jpg')
    if exist(img_filename, "file") == 0
        continue;
    end   
    img = imread(img_filename);
    img2 = rgb2gray(img);
    se = strel('disk',3);
    se2 = strel('disk',3);
    img_opened = imopen(img,se);
    img_closed = imclose(img,se2);

    [circleiris circlepupil imagewithnoise] = segmentiris(img2);
    imageswithcircles = uint8(img2);

    %get pixel coords for circle around iris
    [x,y] = circlecoords([circleiris(2),circleiris(1)],circleiris(3),size(img2));
    % [x,y] = circlecoords([a(2),a(1)],a(3), size(img));
    ind2 = sub2ind(size(img2),double(y),double(x)); 

    %get pixel coords for circle around pupil
    [xp,yp] = circlecoords([circlepupil(2),circlepupil(1)],circlepupil(3),size(img2));
    % [xp,yp] = circlecoords([xc,yc]),radius,size(img);
    ind1 = sub2ind(size(img2),double(yp),double(xp));

    imagewithcircles(ind2) = 255;
    imagewithcircles(ind1) = 255;

    %normalisation parameters
    radial_res = 20;
    angular_res = 240;

    % [polar_array noise_array] = normaliseiris(c,a(2),...
    %      a(1),a(3),xc,yc,radius,img_closed,radial_res,angular_res);

    [polar_array noise_array] = normaliseiris(imagewithnoise, circleiris(2),...
    circleiris(1), circleiris(3), circlepupil(2), circlepupil(1), circlepupil(3),img_closed, radial_res, angular_res);

    %feature encoding parameters
    nscales=1;
    minWaveLength=18;
    mult=1; % not applicable if using nscales = 1
    sigmaOnf=0.5;

    [template mask] = encode(polar_array, noise_array, nscales, minWaveLength, mult, sigmaOnf);   
    cd('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\right_iris\templates\')
    imwrite(template, strcat('a',num2str(iris),'RI_',num2str(iris1),'.jpg'),'jpg');
    imwrite(mask,strcat('b',num2str(iris),'RI_',num2str(iris1),'.jpg'),'jpg');
    template1 = imread(strcat('a',num2str(iris),'RI_',num2str(iris1),'.jpg'));
    mask1 = imread(strcat('b',num2str(iris),'RI_',num2str(iris1),'.jpg'));

    end
end









