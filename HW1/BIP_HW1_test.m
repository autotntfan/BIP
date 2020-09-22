clear;
load HW1_brain.mat;
rgbimg=HW1_brain;
figure("Name","RGB MRI");
imagesc(rgbimg);
level=[256 128 64 32 16 8 4 2];

for i=1:length(level)
    X=subplot(4,2,i);
    scale=level(i);
    %figure("Name",['Gray',num2str(scale),'MRI']);
    imagesc(rgbimg);
    colormap(X,gray(scale));
    title(['Gray',num2str(scale),'MRI']);
    if scale==8
        gray8=colormap(X,gray(scale));
    else if scale==2
            gray2=colormap(X,gray(scale));
        end
    end

end
% IP=input('gray-scale level=>');
% figure("Name",['Gray',num2str(IP),'MRI']);
% imagesc(rgbimg);
% colormap(gray(IP));

