clear;
load HW2_brain.mat;
rgbimg=HW2_brain;

%使用內建
figure("Name","histogram of brain");
histogram(rgbimg,256)
figure("Name","histogram equalization of brain by histeq");
histeq(rgbimg);
histimg=histeq(rgbimg);
figure('Name','histogram of img by histeq');
histogram(histimg,256);




%計算原始圖片各灰階值有幾個 例如r0=0 nk=1638 r1=1 nk=8338
%histcounts(image,grayscale) 
Nk=histcounts(rgbimg,256);

%histogram(image,grayscale,'Category','name');
%計算CDF
figure('Name','histogram of brain  CDF');
Histcdf=histogram(rgbimg,256,'Normalization','cdf');
%T(r)=CDF(in propability,MAX=1)*grayscale
CDF=255*Histcdf.Values;

%find the nearest integer
CDF_prime=round(CDF);

%pixel:欲生成的histogram  
%Histimg:欲生成的圖片
pixel=zeros(1,256);
Histimg=zeros(224,224);

for i =1:length(CDF_prime)
    %查找CDF_prime中存在的intensity，例如第一個為intensity=8
    %對應nk為1638，即轉換過後s8的pixel=1638，s0~s7=0
    %第二個為intensity=51，對應nk為8338，即轉換過後s51的pixel=8338，s8~s50=0
    %需特別注意matlab計數由1開始，因此找到的第一個值intensity=8，ind=1
    %實際上它代表的是s0，尋找影像強度為0的pixel須將值-1，即ind-1=0才會符合影像
    %強度=0，否則會變成尋找影像強度為1的pixel
    
    ind=find(CDF_prime==i); %查index
        
    if ~isempty(ind) %若經四捨五入後值不存在，例如0~7，則其值為0
        
        if ind==1 %將原本強度為0的pixel轉換成強度為8
            [m,n]=find(rgbimg==0);
            for j=1:length(m)
                Histimg(m(j),n(j)) = i;
            end
            %將pixel數填入，以製成bar
            pixel(i)=sum(Nk(ind));
        else 
            %ind>1的值處理完，例如第二個值為51，i=51、ind=2，將原本強度為2的
            %pixel數量填入"pixel"、將強度2增強到51
            pixel(i)=sum(Nk(ind));
            for k =1:length(ind)
                [m,n]=find(rgbimg==ind(k)-1);
                %[m,n]=[row,column]，這些索引對應到原本強度為"ind"的pixel
                for j=1:length(m)
                    Histimg(m(j),n(j)) = i;
                end
            end
        end
    end
end

%plot histogram
figure('Name','histogram of brain by script');
bar(pixel,1);

%figure
figure('Name','histogram equalization of brain by script');
imagesc(Histimg);
colormap(gray(256));

