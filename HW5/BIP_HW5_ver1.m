clear;
close all;
load HW5_ima1;
load HW5_ima2;
load HW5_ima3;
figure;imshow(ima1,[]);
figure;imshow(ima2,[]);
figure;imshow(ima3,[]);

%% -------------------------------------------problem 1 (a)-------------------------------------------
% (x1,y1) ----- (x1,y2)  c=[x1 x2]
%           |   |
%           |   |
% (x2,y1) ----- (x2,y2)  r=[y1 y2]

x = [20 50 50 20];    %---->
y = [100 100 10 10]; %��

%----------------------------------ima 1----------------------------------

%�o�X�ؤ����Ϥ������s��matrix�H��K����@�~
matrix_1=ima1(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
BW_1 = roipoly(ima1,x,y);
[R_1 C_1]=size(BW_1);
ROI_1=zeros(R_1,C_1);
for ii=1:R_1
    for jj=1:C_1
        if BW_1(ii,jj)==1
            ROI_1(ii,jj)=ima1(ii,jj);
        end
    end
end
figure;imshow(ROI_1,[]);
xlabel("(region of interest -- ima1)");
noise_img_1=DetectNoise(ROI_1,matrix_1);
figure;imshow(noise_img_1,[]);
xlabel("(noise in the region of interest -- ima1)");
ROI_1=noise_img_1(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
%�ѩ�Ȭ�0���a��L�h�ϱohistogram�Ϯ״X�G�u�ݱo��0������
%�]���N0��������ܥX�ӡA�u���1�H���̤j�Ȫ��϶�
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
        end
    end
end
%�Y�����ϥ�imshow(ROI_2,[]);�|�ɭP�G���ܩ��G�A�]��[]���|�N���X�{���̤j�̤p��normalizaion
figure;imshow(ROI_2,[]);
xlabel("(region of interest -- ima2)");
noise_img_2=DetectNoise(ROI_2,matrix_2);
figure;imshow(noise_img_2,[]);
xlabel("(noise in the region of interest -- ima2)");
ROI_2=noise_img_2(min(y(:)):max(y(:)),min(x(:)):max(x(:)));
%�ѩ�Ȭ�0���a��L�h�ϱohistogram�Ϯ״X�G�u�ݱo��0������
%�]���N0��������ܥX�ӡA�u���1�H���̤j�Ȫ��϶�
figure;histogram(ROI_2,1:max(ROI_2(:)));
xlabel("(histogram of the noise in the region of interest -- ima2)");
figure;histogram(ROI_2,1:max(ROI_2(:)),'Normalization','pdf');


%% -------------------------------------------problem 1 (b)-------------------------------------------

%�ѩ�Ĥ@�i�Ϥ����T���VImpulse noise�A�]���Ĥ@���o�i�����median filter
NO_noise_ima1=medfilt2(ima1);
figure;imshowpair(ima1,NO_noise_ima1,'montage');
xlabel("(After median filter -- ima1)");
%geometric mean filter isn't built-in
%reference:https://stackoverflow.com/questions/41287452/geometric-mean-filter-for-denoising-image-in-matlab
%����log�O�]��log�ۥ[=��ƭȬۭ��A�����ϥ�imfilter���n���P��N�d�򤺩Ҧ����Ȭۭ�
%�A��exp�N�Ȩ��X
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


% %�ѩ�ĤG�i�Ϥ����T���VRayleigh/Gamma/exponential noise�A�]���Ĥ@���o�i�����wiener filter
wiener_filter_ima1=wiener2(ima2,[3,3]);
figure;imshowpair(ima2,wiener_filter_ima1,'montage');
xlabel("(After wiener filter -- ima2)");

ari_mean_ima1 = imfilter(wiener_filter_ima1, ari_mean_filter);
figure;imshowpair(ima2,ari_mean_ima1,'montage');
xlabel("(After wiener filter and arithmetic mean filter -- ima2)");


function noise_img=DetectNoise(input_img,matrix)
    %if the pixel is between m-s and m+s,then it is a signal otherwise
    %noise,where m is the mean and s is the standard deviation of the kernel.
    %reference:https://stackoverflow.com/questions/22434482/error-image-noise-detection-in-matlab/22438813
    [R C]=size(input_img);
    noise_img=zeros(R,C);
    z=zeros(2+R,2+C);
    z(2:1+R,2:1+C)=input_img;
    %�ѦҸ�ƥ�1�ӼзǮt���Z�A���ڻ{��1�ӼзǮt������T�P�w���P
    %�g���й��ի�A�令2.3�ӼзǮt
    for ii = 2:R+1
        for jj = 2:C+1
            range=z(ii-1:ii+1,jj-1:jj+1);    
            s=std2(range);
            m=mean2(range);
            min_range=m-2.3*s;
            max_range=m+2.3*s;
            if input_img(ii-1,jj-1)<=min_range | input_img(ii-1,jj-1)>=max_range
                noise_img(ii-1,jj-1)=input_img(ii-1,jj-1);
            end
        end
    end
end


 
    
                
                
    
