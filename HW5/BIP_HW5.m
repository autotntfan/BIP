clear;
close all;
load HW5_ima1;
load HW5_ima2;
load HW5_ima3;
figure;imshow(ima1,[]);
figure;imshow(ima2,[]);
figure;imshow(ima3,[]);

%% -------------------------------------------problem 1 (a)-------------------------------------------
% (x21,y21) ----- (x22,y22)  c=[x21 x22 x12 x11]
%           |   |
%           |   |
% (x11,y11) ----- (x12,y22)  r=[y21 y22 y12 y11]

x = [20 50 50 20];
y = [100 100 10 10];
%----------------------------------ima 1----------------------------------

%濾出框內的圖片像素存於matrix以方便後續作業
matrix_1=ima1(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
BW_1 = roipoly(ima1,x,y);
[R_1 C_1]=size(BW_1);
ROI_1=zeros(R_1,C_1);
for ii=1:R_1
    for jj=1:C_1
        if BW_1(ii,jj)==1
            ROI_1(ii,jj)=ima1(ii,jj);
        else
            ROI_1(ii,jj)=0;
        end
    end
end
figure;imshow(ROI_1,[]);
xlabel("(region of interest -- ima1)");
noise_img_1=DetectNoise(ROI_1,matrix_1);
figure;imshow(noise_img_1,[]);
xlabel("(noise in the region of interest -- ima1)");
ROI_1=noise_img_1(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
%由於值為0的地方過多使得histogram圖案幾乎只看得到0的部分
%因此將0部分不顯示出來，只顯示1以後到最大值的區間
figure;histogram(ROI_1,1:max(ROI_1(:)));
xlabel("(histogram of the noise in the region of interest -- ima1)");
figure;histogram(ROI_1,1:max(ROI_1(:)),'Normalization','pdf');
%----------------------------------ima 2----------------------------------
matrix_2=ima2(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
BW_2 = roipoly(ima2,x,y);
[R_2 C_2]=size(BW_2);
ROI_2=zeros(R_2,C_2);
for ii=1:R_2
    for jj=1:C_2
        if BW_2(ii,jj)==1
            ROI_2(ii,jj)=ima2(ii,jj);
        else
            ROI_2(ii,jj)=0;
        end
    end
end
figure;imshow(ROI_2,[]);
xlabel("(region of interest -- ima2)");
noise_img_2=DetectNoise(ROI_2,matrix_2);
figure;imshow(noise_img_2,[]);
xlabel("(noise in the region of interest -- ima2)");
ROI_2=noise_img_2(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
%由於值為0的地方過多使得histogram圖案幾乎只看得到0的部分
%因此將0部分不顯示出來，只顯示1以後到最大值的區間
figure;histogram(ROI_2,1:max(ROI_2(:)));
xlabel("(histogram of the noise in the region of interest -- ima2)");
figure;histogram(ROI_2,1:max(ROI_2(:)),'Normalization','pdf');


%% -------------------------------------------problem 1 (b)-------------------------------------------

%由於第一張圖片雜訊偏向Impulse noise，因此第一個濾波器選用median filter
NO_noise_ima1=medfilt2(ima1);
figure;imshowpair(ima1,NO_noise_ima1,'montage');
xlabel("(After median filter -- ima1)");
%geometric mean filter isn't built-in
%reference:https://stackoverflow.com/questions/41287452/geometric-mean-filter-for-denoising-image-in-matlab
%先取log是因為log相加=原數值相乘，直接使用imfilter卷積等同於將範圍內所有的值相乘
%再取exp將值取出
mask_size=ones(3,3);
geo_mean_ima1 = imfilter(log(double(NO_noise_ima1)), mask_size, 'replicate');
geo_mean_ima1 = exp(geo_mean_ima1);
geo_mean_ima1 = geo_mean_ima1 .^ (1/numel(mask_size));
figure;imshowpair(ima1,geo_mean_ima1,'montage');
xlabel("(After median filter and geometric mean filter -- ima1)");

%arithmetic mean filter
ari_mean_filter = fspecial('average');
ari_mean_ima1 = imfilter(NO_noise_ima1, ari_mean_filter);
figure;imshowpair(ima1,ari_mean_ima1,'montage');
xlabel("(After median filter and arithmetic mean filter -- ima1)");

%wiener filter
wiener_filter_ima1=wiener2(NO_noise_ima1,[3,3]);
figure;imshowpair(ima1,wiener_filter_ima1,'montage');
xlabel("(After median filter and wiener filter  -- ima1)");


% %由於第二張圖片雜訊偏向Rayleigh/Gamma/exponential noise，因此第一個濾波器選用wiener filter
wiener_filter_ima1=wiener2(ima2,[3,3]);
figure;imshowpair(ima2,wiener_filter_ima1,'montage');
xlabel("(After wiener filter -- ima2)");

ari_mean_ima1 = imfilter(wiener_filter_ima1, ari_mean_filter);
figure;imshowpair(ima2,ari_mean_ima1,'montage');
xlabel("(After wiener filter and arithmetic mean filter -- ima2)");


function noise_img=DetectNoise(input_img,matrix)
    %Kernel size =(3,3)
    %if the pixel is between m-s and m+s,then it is a signal otherwise
    %noise,where m is the mean and s is the standard deviation of the kernel.
    %reference:https://stackoverflow.com/questions/22434482/error-image-noise-detection-in-matlab/22438813
    kernel_size=[3 3];
    [r c]=size(input_img);
    noise_img=zeros(r,c);
    s=std2(matrix);
    m=mean2(matrix);
    %參考資料用1個標準差當間距，但我認為1個標準差對於雜訊判定太鬆
    %經反覆嘗試後，改成2個標準差
    min_range=m-2*s;
    max_range=m+2*s;
    noise_img=zeros(r,c);
    for ii = 1:r
        for jj = 1:c
            if input_img(ii,jj)<=min_range | input_img(ii,jj)>=max_range
                noise_img(ii,jj)=input_img(ii,jj);
            end
        end
    end
end
                
 
    
                
                
    
