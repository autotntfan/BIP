clear;
load HW2_brain.mat;
rgbimg=HW2_brain;

%�ϥΤ���
figure("Name","histogram of brain");
histogram(rgbimg,256)
figure("Name","histogram equalization of brain by histeq");
histeq(rgbimg);
histimg=histeq(rgbimg);
figure('Name','histogram of img by histeq');
histogram(histimg,256);




%�p���l�Ϥ��U�Ƕ��Ȧ��X�� �Ҧpr0=0 nk=1638 r1=1 nk=8338
%histcounts(image,grayscale) 
Nk=histcounts(rgbimg,256);

%histogram(image,grayscale,'Category','name');
%�p��CDF
figure('Name','histogram of brain  CDF');
Histcdf=histogram(rgbimg,256,'Normalization','cdf');
%T(r)=CDF(in propability,MAX=1)*grayscale
CDF=255*Histcdf.Values;

%find the nearest integer
CDF_prime=round(CDF);

%pixel:���ͦ���histogram  
%Histimg:���ͦ����Ϥ�
pixel=zeros(1,256);
Histimg=zeros(224,224);

for i =1:length(CDF_prime)
    %�d��CDF_prime���s�b��intensity�A�Ҧp�Ĥ@�Ӭ�intensity=8
    %����nk��1638�A�Y�ഫ�L��s8��pixel=1638�As0~s7=0
    %�ĤG�Ӭ�intensity=51�A����nk��8338�A�Y�ഫ�L��s51��pixel=8338�As8~s50=0
    %�ݯS�O�`�Nmatlab�p�ƥ�1�}�l�A�]����쪺�Ĥ@�ӭ�intensity=8�Aind=1
    %��ڤW���N���Os0�A�M��v���j�׬�0��pixel���N��-1�A�Yind-1=0�~�|�ŦX�v��
    %�j��=0�A�_�h�|�ܦ��M��v���j�׬�1��pixel
    
    ind=find(CDF_prime==i); %�dindex
        
    if ~isempty(ind) %�Y�g�|�ˤ��J��Ȥ��s�b�A�Ҧp0~7�A�h��Ȭ�0
        
        if ind==1 %�N�쥻�j�׬�0��pixel�ഫ���j�׬�8
            [m,n]=find(rgbimg==0);
            for j=1:length(m)
                Histimg(m(j),n(j)) = i;
            end
            %�Npixel�ƶ�J�A�H�s��bar
            pixel(i)=sum(Nk(ind));
        else 
            %ind>1���ȳB�z���A�Ҧp�ĤG�ӭȬ�51�Ai=51�Bind=2�A�N�쥻�j�׬�2��
            %pixel�ƶq��J"pixel"�B�N�j��2�W�j��51
            pixel(i)=sum(Nk(ind));
            for k =1:length(ind)
                [m,n]=find(rgbimg==ind(k)-1);
                %[m,n]=[row,column]�A�o�ǯ��޹�����쥻�j�׬�"ind"��pixel
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

