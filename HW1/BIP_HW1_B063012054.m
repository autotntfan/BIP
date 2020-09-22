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

for i=1:length(level)
    figure("Name",['Gray MRI-',num2str(level(i))]);
    scale=1/(level(i)-1);
    %for gray-scale level=256
    %0~1/256=0¡B1/256~2/256=1¡B2/256~3/256=2...
    Img=round(grayimg./scale);
    img=Img/(level(i)-1);
    %subplot(4,2,i); %Remove'figure("Name",['Gray MRI-',num2str(level(i))]);'
    imshow(img);
    title(['Gray',num2str(level(i)),'MRI']);
    %Get the grayscale-256 img
    if scale==1/255
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
            






