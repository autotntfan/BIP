clear;
close all;
files={'HW8_fix.mat','HW8_warp.mat','HW8_Irad.mat','HW8_Itof.mat',"BIP_HW8_points.mat"};
for ii=1:numel(files)
    load(files{ii});
end
figure,imshow(I1,[]);
% question 1 pictures：I1、I2warp
% POI:getpts   ROI:roipoly(img) 其中getpts定義x為水平向右方向 y為垂直向下方向
% 為方便日後調用，作業選擇的點已使用函數'savepoint'存入'BIP_HW8_points.mat'並讀取
% % savepoint(I2warp,I1);
points=HW8_points
%第一組向量 水平 螢幕上中點至螢幕右上角
vector1_tilt=[points(1,2)-points(1,1),points(2,2)-points(2,1)];
vector1=[points(3,2)-points(3,1),points(4,2)-points(4,1)];
%第二組向量 水平 螢幕下中點至螢幕右下角
vector2_tilt=[points(1,6)-points(1,5),points(2,6)-points(2,5)];
vector2=[points(3,6)-points(3,5),points(4,6)-points(4,5)];
%第三組向量 水平 窗框左點至窗框右點
vector3_tilt=[points(1,8)-points(1,7),points(2,8)-points(2,7)];
vector3=[points(3,8)-points(3,7),points(4,8)-points(4,7)];
%第四組向量 水平 書本左上角至書本右上角
vector4_tilt=[points(1,10)-points(1,9),points(2,10)-points(2,9)];
vector4=[points(3,10)-points(3,9),points(4,10)-points(4,9)];
%第五組向量 垂直 螢幕中上點至螢幕中下點
vector5_tilt=[points(1,5)-points(1,1),points(2,5)-points(2,1)];
vector5=[points(3,5)-points(3,1),points(4,5)-points(4,1)];
%第六組向量 垂直 螢幕右上角至螢幕右下角
vector6_tilt=[points(1,6)-points(1,2),points(2,6)-points(2,2)];
vector6=[points(3,6)-points(3,2),points(4,6)-points(4,2)];
%第七組向量 垂直 窗簾中點至窗簾下方
vector7_tilt=[points(1,7)-points(1,3),points(2,7)-points(2,3)];
vector7=[points(3,7)-points(3,3),points(4,7)-points(4,3)];
%第八組向量 垂直 窗框中點至窗框下方
vector8_tilt=[points(1,8)-points(1,4),points(2,8)-points(2,4)];
vector8=[points(3,8)-points(3,4),points(4,8)-points(4,4)];

%data:第一列(row)為伸縮倍數 第二列(row)為夾角
data=zeros(2,8);
for ii = 1:8
    [data(1,ii),data(2,ii)]=vtheta(eval(['vector' num2str(ii) '_tilt']),eval(['vector' num2str(ii)]));
end
%計算水平轉了幾度，查看了伸縮倍數大約都是1倍因此視為做旋轉和shearing
hrz_theta=max(data(2,1:4));
pdc_theta=max(data(2,5:8));
rotate_img=rotate(I2warp,hrz_theta);
figure,imshow(rotate_img,[]);
rotate_img=imrotate(I2warp,hrz_theta);
% [Fr,Fc]=find(rotate_img~=0,1,'first');
% [Lr,Lc]=find(rotate_img~=0,1,'last');
% rotate_img=rotate_img(Fr:Lr,Fc:Lc);
figure,imshow(rotate_img,[]);
% [m,n]=size(rotate_img);
% pdc_len=round(m/sec(pdc_theta*pi/180));
% hrz_len=round(n-m*tan(pdc_theta*pi/180));

newImage=zeros(pdc_len,hrz_len);
for ii=1:pdc_len
    f=find(rotate_img(ii,:)~=0,1,'first');
    if (f+hrz_len)>1000
        newImage(ii,1:1001-f)=rotate_img(ii,f:end);
    else
        newImage(ii,:)=rotate_img(ii,f:(f+hrz_len-1));
    end
end
figure,imshow(newImage,[]);

function savepoint(img1,img2)
% 找尋12個點，分別為6組垂直平行線與6組水平平行線:
    HW8_points=zeros(4,10);
    figure,imshow(img1);
    [x,y]=getpts;
    HW8_points(1,:)=x,HW8_points(2,:)=y
    figure,imshow(img2);
    [x,y]=getpts;
    HW8_points(3,:)=x,HW8_points(4,:)=y
    save("BIP_HW8_points.mat",'HW8_points');
end

function [scale,theta]=vtheta(u,v)
    theta=acos(dot(u,v)/(sqrt(dot(u,u))*sqrt(dot(v,v))))*180/pi;
    scale=sqrt(dot(u,u))/sqrt(dot(v,v));
end

function newImage=rotate(img,rot)
img=double(img);
[m,n]=size(img);
O=round([m n]./2); %O(y,x)
newImage=zeros(max([m,n]));
data=zeros(400000,3);
count=1;
%ii:y jj:x
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        x=jj-O(2);y=O(1)-ii;
        theta=atan(y/x)*180/pi;
        if theta<0
            if x<0
                theta=180+theta;
            else
                theta=360+theta;
            end
        else
            if x<0
                theta=180+theta;
            else
                theta=theta;
            end
        end
        dist=sqrt(x^2+y^2);
        data(count,:)=[img(ii,jj),dist,theta];
        count=count+1;
    end
end

data(:,3)=data(:,3)+rot;   
last=find(data(:,1)~=0,1,'last');
for kk =1:last
    if data(kk,3)>360
        data(kk,3)=data(kk,3)-360;
    end
    deg=double(data(kk,3)*pi/180);
    if isnan(deg) 
        continue
    end
    x=O(2)+round(data(kk,2)*cos(deg))+(m-n)/2;
    y=O(1)-round(data(kk,2)*sin(deg));
    newImage(y,x)=data(kk,1);
end
end