%part2-(a)
clear;
close all;

%read HW2 MRI image
load HW2_brain.mat;
grayimg=HW2_brain;
figure('Name','Original image');
imshow(grayimg,[]);

%laplacian filter
laplacian=[1 1 1;1 -8 1;1 1 1];
figure('Name','laplacian filter');
grad=abs(filter2(laplacian,grayimg,'same'));
imshow(grad,[]);

%use 'edge' to deal with image
logimg=edge(grayimg,'log');
figure('Name','use edge log ');
imshow(logimg);

%Histogram Equalization
figure('Name','After histogram equalization');
histimg=histeq(grayimg);
imshow(histimg);
%laplacian filter with Histogram Equalization
figure('Name','laplacian filter with histogram equalization');
grad_H=abs(filter2(laplacian,histimg,'same'));
imshow(grad_H,[]);
%use 'edge' to deal with image
logimg_H=edge(histimg,'log');
figure('Name','use edge log with histogram equalization');
imshow(logimg_H);

%part2-(b)
%reference¡Ghttps://www.itread01.com/content/1549918990.html
figure('Name','part2-(b)');
Filter1=fspecial('disk',5.2);
Filter2=fspecial('average',[3,3]);
Filter3=fspecial('gaussian',[3,3],0.5);
blurimg=filter2(Filter1,grayimg,'same');
blurimg=filter2(Filter2,blurimg,'same');
blurimg=filter2(Filter3,blurimg,'same');

imshow(blurimg,[])