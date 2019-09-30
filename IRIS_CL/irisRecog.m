close all;
clear all;clc;
img_filename = 'C:\Users\ONI\Desktop\NewIrisRecog\samplepaper\LEFT IRIS\right_iris\.jpg';
img = imread(img_filename);
img2 = rgb2gray(img);
%imshow(img2);
thresh_img = graythresh(img);
se = strel('disk',3);
se2 = strel('disk',3);
img_opened = imopen(img,se);
img_closed = imclose(img,se2);
thresh = 0.25;
%creating bianry mask of all the images 
binary_open = im2bw(img_opened,thresh);
binary_closed = im2bw(img_closed,thresh);
new = ones(size(binary_open));
new2 = abs(new-binary_open);
image_edges = edge(binary_open,'canny',0.9);
new2 = bwareaopen(new2,30);
%Trace region boundaries in binary image
[B,L] = bwboundaries(new2,'noholes');

%displays label matrix and draw each boundary
%imshow(label2rgb(L,@jet,[5,5,5]));
for k = 1:length(B)
    boundary = B{k};
    %plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

stats = regionprops(L,'Area','Centroid');
threshold = 0.4;
%loop over the boundaries
for k = 1:length(B)
    boundary = B{k};
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq,2)));
    
    area = stats(k).Area;
    metric = 4*pi*area/perimeter^2;
    metric_string = sprintf('%2.2f',metric);
    %To mark objects above the threshold with black circle
    if metric>threshold
        centroid = stats(k).Centroid;
        plot(centroid(1),centroid(2),'ko');
        
        x = boundary(:,2);
        y = boundary(:,1);
        
        %solve for parameters abc in d least square sense by using the
        %backslash operator
        abc = [x y ones(length(x),1)]\-(x.^2+y.^2);
        a = abc(1); b = abc(2); c =abc(3);
        
        %calculate the location of center and radius
        xc = -a/2;
        yc = -b/2;
        radius = sqrt((xc^2+yc^2)-c);
        
        %to display calculated center
        %plot(xc,yc,'yx','LineWidth',2);
        
        %plot the entire circle
        theta = 0:0.01:2*pi;
        %use parametric representation to obtain the coordinates of the circle
        Xfit = radius*cos(theta)+xc;
        Yfit = radius*sin(theta)+yc;
        
        %plot(Xfit,Yfit);
        
        message = sprintf('The estimated radius is %2.3f pixels',radius);
        text(15,15,message,'Color','y','FontWeight','bold');
    end
    text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
        'FontSize',14,'FontWeight','bold');
end

[circleiris circlepupil imagewithnoise] = segmentiris(img2);

% [a b c] = segmentiris(img);

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
cd('C:\Users\ONI\Desktop\NewIrisRecog\Images\new images\vary_thresh')
imwrite(template,'e.jpg','jpg');
imwrite(mask,'f.jpg','jpg');
template1 = imread('e.jpg');
mask1 = imread('f.jpg');
%cd(w)

c = gethammingdistance(template,mask,template1,mask1,nscales);
if c>0 && c<0.39
    disp('Iris recognized')
    disp(strcat('The Hamming distance is =',num2str(c)))
else
    disp('Iris not recognized')
    disp(c)
end
% e = toc;
% disp(strcat('Recognition time is=',num2str(e)))

%%-----------------------Figures-------------------------%%
% figure(1);
% imshow(img);
% title('Raw iris')
% figure(2)
% imshow(img_opened,[])
% title('morphological opening')
% figure(3)
% imshow(img_closed);
% title('morphological closing')
% figure(4)
% imshow(new2);
% title('Binary compilment of the morphological image')
% figure(5)
% imshow(binary_open);
% title('Morphological Opening')
% figure(6)
% imshow(binary_closed);
% title('Morphological Closing')
% figure(7)
% imshow(image_edges);
% title('Edges in the image')
% figure(8)
% imshow(polar_array);
% title('Polar array')
% figure(9)
% imshow(noise_array);
% title('Noise array')
% figure(10)
figure(1)
imshow(template);
title('Binary iris biometric template')
figure(2)
imshow(mask);
title('Binary iris noise mask') 

% [x y] =size(img_opened);
% xi = [0 160]
% yi = [0 150]
% 
% xdat = [1 x]; 
% ydat = [1 y];







