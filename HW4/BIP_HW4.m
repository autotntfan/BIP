close all;
clear;
load HW1_brain.mat;
figure;imshow(HW1_brain,[]);
title('original image');
colorbar;
doubleimg=HW1_brain;
%%  ------------------------------------------Q.(a)-----------------------------------------

%forward FFT
F=fft2(doubleimg);
FFT=fftshift(F);
%find Real part,Imaginary part and magnitude.
Re_part=real(FFT);
Im_part=imag(FFT);
Magnitude=abs(FFT);
figure,imshow(Re_part,[]);
xlabel('real part');
figure,imshow(Im_part,[]);
xlabel('Imaginary part');


%abs取強度 1+abs(FFT)防止log0無定義 
%reference:https://stackoverflow.com/questions/13549186/how-to-plot-a-2d-fft-in-matlab
FFT_a=log(1+Magnitude);
figure;imshow(FFT_a,[]);
title('FFT');
%inverse FFT
IFFT_a=ifft2(fftshift(FFT));
figure;imshow(IFFT_a,[]);
title('inverse FFT');
colorbar;
figure;plot(abs(IFFT_a));
title('magnitude spectrum');

%%  ------------------------------------------Q.(b)-----------------------------------------
N=size(F,1);
F_b=zeros(224,224);
for ii =N/4:3*N/4
    for jj =N/4:3*N/4
        F_b(ii,jj)=FFT(ii,jj);
    end
end
FFT_b=log(1+abs(F_b));
figure;imshow(FFT_b,[]);
title('FFT N/2-by-N/2 unchanged');

%%  ------------------------------------------Q.(c)-----------------------------------------
D_0_20=20;
D_0_40=40;
GLPF_20=zeros(N,N);
GLPF_40=zeros(N,N);
%Gaussian low pass filter
for u=1:N
    for v=1:N
        D=sqrt((u-N/2)^2+(v-N/2)^2);
        GLPF_20(u,v)=exp(-D^2/(2*D_0_20^2));
        GLPF_40(u,v)=exp(-D^2/(2*D_0_40^2));
    end
end

figure;imshow(GLPF_20,[])
title('GLPF-20');
figure;imshow(GLPF_40,[])
title('GLPF-40');

%將轉換到頻率域的訊號與GLPF做點乘
F_c_20=FFT.*GLPF_20;
%因相位旋轉，獲得的值經inverse FFT會有虛數部分
%將值取實數部分並取絕對值使圖案辨識度上升
%使用Do=20
IFFT_c_20=abs(real(ifft2(F_c_20)));
figure;imshow(IFFT_c_20,[]);
title('IFFT with GLPF-20');
%使用Do=40
F_c_40=FFT.*GLPF_40;
IFFT_c_40=abs(real(ifft2(F_c_40)));
figure;imshow(IFFT_c_40,[]);
title('IFFT with GLPF-40');
%%  ------------------------------------------Q.(d)-----------------------------------------
GHPF_20=ones(N,N)-GLPF_20;
GHPF_40=ones(N,N)-GLPF_40;
F_d_20=FFT.*GHPF_20;
F_d_40=FFT.*GHPF_40;

figure;imshow(GHPF_20,[])
title('GHPF-20');
figure;imshow(GHPF_40,[])
title('GHPF-40');

IFFT_d_20=abs(real(ifft2(F_d_20)));
figure;imshow(IFFT_d_20,[]);
title('IFFT with GHPF-20');
IFFT_d_40=abs(real(ifft2(F_d_40)));
figure;imshow(IFFT_d_40,[]);
title('IFFT with GHPF-40');
%%  ------------------------------------------Q.(e)-----------------------------------------.
%reference1:https://www.cs.uregina.ca/Links/class-info/425/Lab5/lesson.html
%reference2:https://docs.opencv.org/master/de/dbc/tutorial_py_fourier_transform.html
%reference1---matlab,reference2---python
Sobel=[-1. 0 1.;-2. 0 2.;-1. 0 1.];

%---------------------------此區code複製於reference1----------------------
%因為'size(HW1_brain)'維度=2，所以使用'paddedsize'函數所得的值為2*(224,224)
% PQ=paddedsize(size(HW1_brain));
% F = fft2(HW1_brain, PQ(1), PQ(2));
% H = fft2(double(Sobel), PQ(1), PQ(2));
% F_fH = H.*F;
% ffi = ifft2(F_fH);
% ffi = ffi(2:size(HW1_brain,1)+1, 2:size(HW1_brain,2)+1);
% figure;imshow(abs(ffi),[]);
% title('sobel image');
%---------------------------此區code複製於reference1----------------------

%參考reference1、reference2實作以下
%使用fft2時將Sobel拓展維度與圖片大小相同(reference1使用2倍維度，即(448,448))
H = fft2(double(Sobel),224,224);
FFT_Sobel=log(1+abs(fftshift(H)));
figure;imshow(FFT_Sobel,[]);
xlabel('Sobel filter in the frequency domain')
FFT_e=FFT.*FFT_Sobel;
IFFT_e=abs(real(ifft2(FFT_e)));
figure;imshow(IFFT_e>0.3*max(IFFT_e(:)));%用閥值二值化圖片
title('Img processing by Sobel filter');

%courtesy of https://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/paddedsize.m
function PQ = paddedsize(AB, CD, PARAM)
%PADDEDSIZE Computes padded sizes useful for FFT-based filtering.
%   PQ = PADDEDSIZE(AB), where AB is a two-element size vector,
%   computes the two-element size vector PQ = 2*AB.
%
%   PQ = PADDEDSIZE(AB, 'PWR2') computes the vector PQ such that
%   PQ(1) = PQ(2) = 2^nextpow2(2*m), where m is MAX(AB).
%
%   PQ = PADDEDSIZE(AB, CD), where AB and CD are two-element size
%   vectors, computes the two-element size vector PQ.  The elements
%   of PQ are the smallest even integers greater than or equal to 
%   AB + CD -1.
%   
%   PQ = PADDEDSIZE(AB, CD, 'PWR2') computes the vector PQ such that
%   PQ(1) = PQ(2) = 2^nextpow2(2*m), where m is MAX([AB CD]).

if nargin == 1
   PQ = 2*AB;
elseif nargin == 2 & ~ischar(CD)
   PQ = AB + CD - 1;
   PQ = 2 * ceil(PQ / 2);
elseif nargin == 2
   m = max(AB); % Maximum dimension.

   % Find power-of-2 at least twice m.
   P = 2^nextpow2(2*m);
   PQ = [P, P];
elseif nargin == 3
   m = max([AB CD]); %Maximum dimension.
   P = 2^nextpow2(2*m);
   PQ = [P, P];
else
   error('Wrong number of inputs.')
end
end