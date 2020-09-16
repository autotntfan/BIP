clear;
%load file
load HW1_brain.mat;
rgbimg=HW1_brain;
%check img
figure("Name","RGB MRI-1");
imagesc(rgbimg);

level=[256 128 64 32 16 8 4 2];
power=[8 7 6 5 4 3 2 1];
%normalize
grayimg=rgbimg./(max(rgbimg(:))+1);

for i=1:length(power)
    figure("Name",['Gray MRI-',num2str(level(i))]);
    scale=1/power(i);
    %for gray-scale level=256=2^8
    %0~0.125=0¡B0.126~0.25=1¡B0.26~0.375=2...
    Img=round(grayimg./scale);
    img=Img/power(i);
    %subplot(4,2,i); %Remove'figure("Name",['Gray MRI-',num2str(level(i))]);'
    imshow(img);
    title(['Gray',num2str(level(i)),'MRI']);
    %Get the grayscale-256 img
    if scale==1/8
        gray256=img;      
    end
end
%Q(b)
ans2b=gray256;
for ii =1:224
    for jj=1:224
        if gray256(ii,jj) < 1
            ans2b(ii,jj)=0;
        end
    end
end
figure("Name",'(b)');
imshow(ans2b);
%Q(c)
ans2c=gray256;
for ii =1:224
    for jj=1:224
        if gray256(ii,jj) == 1
            ans2c(ii,jj)=0;
        end
    end
end
figure("Name",'(c)');
imshow(ans2c);
%Q(d)
ans2d=gray256;
for ii =1:224
    for jj=1:224
        if gray256(ii,jj) == 0
            ans2d(ii,jj)=0;
        end
    end
end
figure("Name",'(d)');
imshow(ans2d);
            






