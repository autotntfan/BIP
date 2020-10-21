%HW5_problem 2
clear;
close all;
load HW5_ima3;
cater = ima3;
%fspecial('motion',len,theta)
psf = fspecial('motion',18,45);
%deconvwnr(I,psf,nsr)
cater_recover = deconvwnr(cater,psf,0.4);
%imbilatfilt(I,degreeOfSmoothing,spatialSigma)
New=imbilatfilt(cater_recover,30,5);

figure,imshowpair(cater,New,'montage')



