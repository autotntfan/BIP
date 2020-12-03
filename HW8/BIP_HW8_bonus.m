clear; close all;
files={'HW8_Irad.mat','HW8_Itof.mat','HW5_ima3.mat'};
for ii=1:numel(files)
    load(files{ii});
end
region=[107 121 189 203]; %x1=107 x2=121 y1=189 y2=203 dim=15*15
figure,imshow(Irad,[]);
hold on;
%show the selected region  of Irad
plot([region(1) region(2) region(2) region(1) region(1)],[region(3) region(3) region(4) region(4) region(3)],'r-');
ROI=Irad.*roipoly(Irad,[region(1) region(1) region(2) region(2)],[region(3) region(4) region(4) region(3)]); %dim=240*240
%show the ROI of Irad
figure,imshow(ROI,[]);
xlabel('selected ROI in figure Irad');
roi=Irad(region(3):region(4),region(1):region(2)); %dim=15*15
[m,n]=size(Itof);
data=zeros(m);
%�p��Irad��SSS�ϰ�(ROI)�PItof��i�Ϫ�MI���Y�A�NMI�Ȧs�Jdata��
for ii = 8:m-7
    for jj = 8:n-7
        r=Itof(ii-7:ii+7,jj-7:jj+7);
        I=MI(r,roi);
        data(ii,jj)=I;
    end
end
%ø�XItof��i�Ϩ̧ǥѥ��W�ܥk�U�ϥ�15*15kernel�p��Ӱϰ�PROI��MI���Y
figure,mesh(data);
axis tight;
[r,c]=find(data==max(data(:)));
xmax=c;ymax=r;zmax=data(r,c);
hold on;
%�ХܥX���I
plot3(xmax,ymax,zmax,'k.','markersize',20)
text(xmax,ymax,zmax,['maximum x=',num2str(xmax),char(14),'  y= ',num2str(ymax),char(14),'  MI= ',num2str(zmax),char(14)])
xlabel('x direction of Itof');
ylabel('y direction of Itof');
zlabel('MI');
title('computed between in the ROI of Irad and the whole Itof');
%�d�߳o�Ӱϰ�bItof��B
figure,subplot(121);
imshow(Itof,[]);
hold on;
plot([xmax-7 xmax-7 xmax+7 xmax+7 xmax-7],[ymax-7 ymax+7 ymax+7 ymax-7 ymax-7],'r-');
xlabel('region SSS of Irad mapping to Itof');
subplot(122);
imshow(Irad,[]);
hold on;
plot([region(1) region(2) region(2) region(1) region(1)],[region(3) region(3) region(4) region(4) region(3)],'r-');
xlabel('region SSS of Irad');
        

% �p���i�ϥ���MI
%�Ĥ@�ձĥ�padding�覡�N���������X����i�ϬۦP
img1_padding=zeros(256);
img1_padding(9:248,9:248)=Irad;
%�ĤG�ձĥΩ�j�N�Ϥ������X��ۦP�A����Ĥ@�թM�ĤG�չϤ����ƻ�t�O
img1_scaling=imresize(Irad,[256,256],'nearest');
%�ĤT�ձĥα���d��MI�O�_�|�U��
img1_rotate=imrotate(img1_scaling,90);
figure,imshowpair(Irad,img1_scaling,'montage');
xlabel('original img and scaling img');
figure,imshowpair(Irad,img1_rotate,'montage');
xlabel('original img and rotated img');
img2=Itof;
Max=MI(img2,img2);
I=MI(img1_padding,img2);
sprintf('padding img has MI=%.4f',I/Max)
I=MI(img1_scaling,img2);
sprintf('scaling img has MI=%.4f',I/Max)
I=MI(img1_rotate,img2);
sprintf('rotated img has MI=%.4f',I/Max)
%�o���F�@�~5���ĤT�i�Ϥ��A���ӬO�������ۤz���Ϥ��A����MI�ȬO�_�ܤp
I=MI(double(ima3),img2);
sprintf('who r u has MI=%.4f',I/Max)
function I=MI(img1,img2)
%find joint pdf :p(x,y)
Pxy=histcounts2(img1,img2,'Normalization','probability');
%marginal pdf f(x)
Px=sum(Pxy,1);
%marginal pdf f(y)
Py=sum(Pxy,2);
PxPy=Py*Px;
ind=find(Pxy>(1e-12));
I=sum(Pxy(ind).*log2(Pxy(ind)./PxPy(ind)));
end
