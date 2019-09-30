close all;
clear all;clc;
w=cd;
%Inter class matching algorithm
disp('Performs left Iris inter class matching')
cd('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\test_iris\')
[FileName,PathName] = uigetfile('*.bmp;*.jpg;','Select the iris to use');
cd(w)
iris1 = ([PathName FileName]);
testiris=iris1;
nscale=1;
FAR=0;
tic
template1=imread(strcat(PathName,'a',FileName));
mask1=imread(strcat(PathName,'b',FileName));
% imshow(mask1);
% pause
% return
for iris=1:10
    PathName1=('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\left_iris\templates\');
    for iris2=1:6
        cd(PathName1)
        template_name = strcat('a',num2str(iris),'LI_',num2str(iris2),'.jpg');
        mask_name = strcat('b',num2str(iris),'LI_',num2str(iris2),'.jpg');

        cd(w)
        if exist(template_name, "file") == 0
            continue;
            
        elseif exist(mask_name, "file") == 0
            continue;
        end
        template2=imread(template_name);
        mask2=imread(mask_name);
        c=gethammingdistance(template1,mask1,template2,mask2,nscale);
        if c==0
            disp('**************************************************')
            original_file = strrep(template_name,'a',''); 
            disp(strcat(original_file, ' iris is present'))
            disp(strcat('Hamming distance is=',num2str(c)))
            disp('**************************************************')
            FAR=FAR+1;
            break
        elseif c>0.1&&c<0.39
            disp('**************************************************')
            original_file = strrep(template_name,'a','');
            disp(strcat(original_file, ' iris is Recognized'))
            %disp(strcat('hamming distance is=',num2str(c)))
            disp('**************************************************')

        else
            original_file = strrep(template_name,'a','');
            disp('**************************************************')
            disp(strcat(original_file, ' iris is not recognized'))
            disp(strcat('Hamming distance is=',num2str(c)))
            disp('**************************************************')

        end
    end
    if c==0
        imgFile = strrep(template_name,'a','');
        recognizedImage=strcat('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\left_iris\',imgFile);
        figure;
        title(imgFile);
        imshow(recognizedImage);
        break
    end    
end

%%

y = input('Do you want to perform for right iris:[y/n]: ','s');
switch y
    case 'y'
        disp('Performing right Iris Inter-class')
        cd('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\test_iris\');
        [FileName,PathName2] = uigetfile('*.bmp;*.jpg;','Select the iris to use');
        nscales = 1;
        iris1 = ([PathName2 FileName]);
        template3=imread(strcat(PathName2,'a',FileName));
        mask3=imread(strcat(PathName2,'b',FileName));
       
        for iris3=1:10
            PathName3 = ('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\right_iris\templates\');
            for iris4 = 1:6
                cd(PathName3)
                template_name4 = strcat('a',num2str(iris3),'RI_',num2str(iris4),'.jpg');
                mask_name4 = strcat('b',num2str(iris3),'RI_',num2str(iris4),'.jpg');
                if exist(template_name4, "file") == 0
                    continue;
            
                elseif exist(mask_name4, "file") == 0
                    continue;
                end
                template4=imread(template_name4);
                mask4=imread(mask_name4);
                
                c=gethammingdistance(template3,mask3,template4,mask4,nscales);
                if c>0.1&&c<0.39
                    original_file = strrep(template_name4,'a','');
                    disp('**************************************************')
                    disp(strcat(original_file, ' iris is Recognized'))
                    disp('**************************************************')
                    FAR=FAR+1;
                elseif c==0
                    original_file = strrep(template_name4,'a','');
                    disp('**************************************************')
                    disp(strcat(original_file, ' iris are the same'))
                    disp(strcat('Hamming distance is=',num2str(c)))
                    disp('**************************************************')
                    break

                else
                    original_file = strrep(template_name4,'a','');
                    disp('**************************************************')
                    disp(strcat(original_file, ' iris is not recognized'))
                    disp(strcat('Hamming distance is=',num2str(c)))
                    disp('**************************************************')
                end
            end
            if c==0
                imgFile1 = strrep(template_name4,'a','');
                recognizedImage1=strcat('C:\Users\ONI\Desktop\LatestIrisRecog\IRIS_CL\black_iris_images\all_image\right_iris\',imgFile1);
                imshow(recognizedImage1);
                break
            end  
        end
        elapsed=toc;
        FAR=(FAR/106)*100;
        disp(['False Acceptance rate is= ',num2str(FAR),'%'])
        elapsed=elapsed/636;
        disp(['Average recognition time is: ',num2str(elapsed),'Secs'])
        optn=input('Do you want to Repeat Operation[y/n]: ','s');
        switch optn
            case 'y'
                Inter_class_matching 
            case 'n'
                return
        end 
    case 'n'
        return
end






