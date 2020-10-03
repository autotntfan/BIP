%part I
clear;
close all;
%read the rgb image
rgbimg=imread('HW3.jpg');
%other image

%rgbimg=imread('arbi.jpg'); % animation image
%rgbimg=imread('Test.jpg'); % camera image

%rgb to gray-256
grayimg=rgb2gray(rgbimg);
figure('Name','gray-256 image');
imshow(grayimg);
%-------------------------------creat kernel-------------------------------
prewitt_x=[1 0 -1;1 0 -1;1 0 -1];
prewitt_y=[-1 -1 -1;0 0 0;1 1 1];

sobel_x=[1 0 -1;2 0 -2;1 0 -1];
sobel_y=[-1 -2 -1;0 0 0;1 2 1];

frei_x=[1 0 -1;sqrt(2) 0 -sqrt(2);1 0 -1];
frei_y=[-1 -sqrt(2) -1;0 0 0;1 sqrt(2) 1];

roberts_x=[1 0;0 -1];
roberts_y=[0 1;-1 0];

ave=fspecial('average',[3,3]);
%--------------------------------------------------------------------------

%use prewitt kernel to calculate x-gradient and y-gradient without image enhancement 
%reference¡Ghttps://blog.csdn.net/zhufanqie/article/details/8709910?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param
figure('Name','prewitt gradient without enhancement ')
subplot(1,2,1);
%get x_gradient
P_gradx=filter2(prewitt_x,grayimg,'same');
P_gradx=abs(P_gradx); 
imshow(P_gradx,[]);
title('prewitt x-gradient of image');
subplot(1,2,2);
%get y_gradient
P_grady=filter2(prewitt_y,grayimg,'same');
P_grady=abs(P_grady); 
imshow(P_grady,[]);
title('prewitt y-gradient of image');

%To reduce complexity,grad=sqrt(gradx.^2+grady.^2) ->grad=gradx+grady
%reference¡Ghttps://www.itread01.com/content/1541476929.html
%%get gradient
P_grad=P_gradx+P_grady;
%set threshold=20 after lots of trial and error
threshold=20;
for ii =1:size(P_grad,1)
    for jj=1:size(P_grad,2)
        if P_grad(ii,jj)<threshold
            P_grad(ii,jj)=0;
        end
    end
end
figure('Name','prewitt without enhancement ');
imshow(P_grad,[]);
title('prewitt gradient of image');

%use sobel kernel to calculate x-gradient and y-gradient without image enhancement 
figure('Name','sobel gradient without enhancement');
subplot(1,2,1);
%get x_gradient
S_gradx=filter2(sobel_x,grayimg,'same');
S_gradx=abs(S_gradx); 
imshow(S_gradx,[]);
title('sobel x-gradient of image');
subplot(1,2,2);
%get y_gradient
S_grady=filter2(sobel_y,grayimg,'same');
S_grady=abs(S_grady); 
imshow(S_grady,[]);
title('sobel y-gradient of image');
%get gradient
S_grad=S_gradx+S_grady;
%set threshold=20 after lots of trial and error
threshold=20;
for ii =1:size(S_grad,1)
    for jj=1:size(S_grad,2)
        if S_grad(ii,jj)<threshold
            S_grad(ii,jj)=0;
        end
    end
end
figure('Name','sobel without  enhancement ');
imshow(S_grad,[]);
title('sobel gradient of image');


%use sobel kernel to calculate x-gradient and y-gradient 
%with image enhancement (Average->Sobel)
figure('Name','after image enhancement');
ave_img_x=abs(filter2(ave,grayimg,'same'));
ave_img=double(grayimg)+ave_img_x;
imshow(ave_img,[]);

figure('Name','sobel with  enhancement ')
S_gradx_R=filter2(sobel_x,ave_img,'same');
S_gradx_R=abs(S_gradx_R); 
S_grady_R=filter2(sobel_y,ave_img,'same');
S_grady_R=abs(S_grady_R); 
S_grad_R=S_gradx_R+S_grady_R;
imshow(S_grad_R,[]);

%-----------------use matlab function 'edge'-----------------
%reference¡Ghttps://blog.csdn.net/keith_bb/article/details/51177199
prewittimg=edge(grayimg,'prewitt');
figure('Name','use edge prewitt ');
imshow(prewittimg);

sobelimg=edge(grayimg,'sobel');
figure('Name','use edge sobel ');
imshow(sobelimg);


    

