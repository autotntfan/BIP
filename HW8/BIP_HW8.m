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
% % SavePoint(I2warp,I1);
points=HW8_points
data=VectorData(points);
%計算水平轉了幾度，查看了伸縮倍數大約都是1倍因此視為做了旋轉和shearing
%取max而不取mean是因為max處理起來比較水平不會歪歪的，雖然只差了1、2度可能是心理作用
hrz_theta=max(data(2,1:4));
pdc_theta=max(data(2,5:8));
rotate_img=RotatePolar(I2warp,hrz_theta);
figure,imshow(rotate_img,[]);
xlabel('myself imrotate in polar coord.');
[points,rotate_img]=RotateMatrix(I2warp,hrz_theta,points);
figure,imshow(rotate_img,[]);
xlabel('myself imrotate in xy coord.');

% rotate_img=imrotate(I2warp,hrz_theta);
% figure,imshow(rotate_img,[]);
% xlabel('builted-in imrotate');

[points,shearing_img]=HorizonShearing(rotate_img,pdc_theta,points);
figure,imshow(shearing_img,[]);
xlabel('myself shearing');
data=VectorData(points);
X=1/mean(data(1,1:4));Y=1/mean(data(1,5:8));
[points,scaling_img]=ScalingMatrix(shearing_img,X,Y,points);
figure,imshow(scaling_img,[]);
xlabel('myself scaling');

global_img=CombinateImg(I1,scaling_img,points);
figure,imshow(global_img,[]);
xlabel('final image');

data=VectorData(points);
function data=VectorData(points)
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
    [data(1,ii),data(2,ii)]=Vtheta(eval(['vector' num2str(ii) '_tilt']),eval(['vector' num2str(ii)]));
end

end

function SavePoint(img1,img2)
% 找尋10個點，分別為4組垂直平行線與4組水平平行線:
    HW8_points=zeros(4,10);
    figure,imshow(img1);
    [x,y]=getpts;
    HW8_points(1,:)=x,HW8_points(2,:)=y
    figure,imshow(img2);
    [x,y]=getpts;
    HW8_points(3,:)=x,HW8_points(4,:)=y 
    save("BIP_HW8_points.mat",'HW8_points');
end

function [scale,theta]=Vtheta(u,v)
%計算向量夾角與長度關係
    theta=acos(dot(u,v)/(sqrt(dot(u,u))*sqrt(dot(v,v))))*180/pi;
    scale=sqrt(dot(u,u))/sqrt(dot(v,v));
end

function newImage=RotatePolar(img,rot)
img=double(img);
[m,n]=size(img);
O=round([m n]./2); %O(y,x)
%為了防止旋轉回去時沒地方放像素，將圖片維度擴張成max(m,n)，但是此方法無法適用於旋轉角度過小的圖片
%較好的方法目前想到是取被旋轉的圖片對角線長度，但是要獲取對角線長度這個資訊需要進行額外的處理
newImage=zeros(max([m,n]));
%通常我不會知道影像實際有多少個Pixels
%因此在儲存時應該用list.append的概念一個接著一個儲存進去而不是設定可以裝N個pixels
%很可能影像超過N個Pixels而出現錯誤，但為了加快程式運算在此就直接設定40萬，實際上只有30幾萬個
data=zeros(400000,3);
count=1;
%ii:y jj:x
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    %定義圖片中心為原點，向四周展開四個象限，角度範圍0~360度
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
        %應該要data=[data;[img(ii,jj),dist,theta]]才正確，但太慢了
        data(count,:)=[img(ii,jj),dist,theta];
        count=count+1;
    end
end
%旋轉
data(:,3)=data(:,3)+rot;  
%後續不存在的資料就不用再處理
last=find(data(:,1)~=0,1,'last');
for kk =1:last
    %將角度範圍限制於0~360
    if data(kk,3)>360
        data(kk,3)=data(kk,3)-360;
    end
    deg=double(data(kk,3)*pi/180);
    %由於arctan會有無定義的狀況(圖片原點處)，因此遇到時選擇無視
    if isnan(deg) 
        continue
    end
    %因為裝圖片的容器dim=(m,m)因此在水平方向需要做平移
    x=O(2)+round(data(kk,2)*cos(deg))+(m-n)/2;
    y=O(1)-round(data(kk,2)*sin(deg));
    %若是僅使用newImage(y,x)=data(kk,1);出來的圖因為round緣故會很多點沒有值
    %密集恐懼症發作很不舒服，因此改成以下填補缺口
    newImage(y,x)=data(kk,1);
    newImage(y+1,x)=data(kk,1);
    newImage(y-1,x)=data(kk,1);
    newImage(y,x+1)=data(kk,1);
    newImage(y,x-1)=data(kk,1);
end
[Fr,Fc]=find(newImage~=0,1,'first');
[Lr,Lc]=find(newImage~=0,1,'last');
newImage=double(newImage(Fr:Lr,Fc:Lc));
end

function [points,newImage]=HorizonShearing(img,theta,points)
%先找到圖片的頂點與末點當作儲存x.y資訊的起點與終點
[Fr,Fc]=find(img~=0,1,'first');
[Lr,Lc]=find(img~=0,1,'last');
img=double(img);
[m,n]=size(img);
%由於圖片以擺平，現在我們要決定新的圖片維度為多少，經由以下幾何思考可知
%-------------------- ----  圖片的高度可由m*sec(垂直旋轉角度)而得
%↑  theta　\             \       長度可由n-x而得，其中x=m*tan(垂直旋轉角度)
% m  　      \     圖片    \
%↓  　       \             \
%-----------------------------
%　←  ｘ    →
%  ←            n          →
pdc_len=round(m*sec(theta*pi/180));
hrz_len=round(n-m*tan(theta*pi/180));
%定義圖片左下角為原點
O=[Lc-hrz_len,Lr];
%為了加快迴圈運算，設定總像素有40w個
data=zeros(400000,4);
%        (n-x) (0,m)
%----------------------------      藉由觀察很明顯知道是水平shearing因此可由
%↑       　\   |           \       (x,y)->(x',y)關係式x+ay=x'反推shearing係數a
% y  　      \  |    圖片    \         a=(x'-x)/y
%↓  　       \ |             \
%              \|              \
%--------------------------------
%　            O               →ｘ方向   
%  
S=(n-hrz_len)/m;
count=1;
%ii:y jj:x
for ii = 1:m
    %不要儲存到每一個row的0，我只要有影像強度的像素點
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        %處理標籤，因為矩陣乘完原本標註的十點xy值會跑掉，因此我需要透過標籤把它找回來
        %並紀錄他被旋轉...等處理後的絕對位置
        [~,loc_1]=find(ii==round(points(2,:)));
        [~,loc_2]=find(jj==round(points(1,:)));
        if ~isempty(loc_1) && ~isempty(loc_2)
            loc=sum(ismember(loc_1,loc_2).*loc_1);    
            %data儲存了intensity、我定義的x座標值、我定義的y座標值、標籤
            data(count,:)=[img(ii,jj),jj-O(1),Lr-ii,loc];
        else

            data(count,:)=[img(ii,jj),jj-O(1),Lr-ii,0];
        end
        count=count+1;
    end
end
%shearing
data(:,2)=round(data(:,2)+S*data(:,3));
last=find(data(:,1)~=0,1,'last');
newImage=zeros(pdc_len,hrz_len);
for kk =1:last
    %將我定義的x,y值轉換成Matlab對應的row,column
    x=O(1)+data(kk,2);
    y=O(2)-data(kk,3);
    newImage(y,x)=data(kk,1);
    if data(kk,4)~=0
        %將被旋轉...等處理過的座標紀錄回points
        points(1,data(kk,4))=x;
        points(2,data(kk,4))=y;
    end
end
[Fr,Fc]=find(newImage>0,1,'first');
[Lr,Lc]=find(newImage>0,1,'last');
newImage=double(newImage(Fr:Lr,Fc:Lc));
%由於影像被裁減了，因此座標需要再處理一次
points(1,:)=points(1,:)-Fc;
points(2,:)=points(2,:)-Fr;
points
end

function [points,newImage]=RotateMatrix(img,theta,points)
img=double(img);
[m,n]=size(img);
O=round([m n]./2); %O(y,x) 定義輸入圖片的正中心為原點，座標軸由原點向四周展開
%定義x.y
%        y
%        ↑
%        ｜
%---------o---------→ x
%        ｜
%        ｜
newImage=zeros(max([m,n]));
count=1;
data=zeros(4,400000);
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        %轉換成我定義的x.y座標值
        x=jj-O(2);y=O(1)-ii;
        
        [~,loc_1]=find(ii==round(points(2,:)));
        [~,loc_2]=find(jj==round(points(1,:)));
        if ~isempty(loc_1) && ~isempty(loc_2)
            %植入標籤
            loc=sum(ismember(loc_1,loc_2).*loc_1);  
            data(:,count)=[img(ii,jj);x;y;loc];
        else
            data(:,count)=[img(ii,jj);x;y;0];
        end
        count=count+1;
    end
end
%rotate
rad=theta*pi/180;
R=[cos(rad) -sin(rad);sin(rad) cos(rad)];
data(2:3,:)=round(R*data(2:3,:));
last=find(data(1,:)~=0,1,'last');
for kk = 1:last
    %轉回Matlab的row,column    
    y=O(1)-data(3,kk);
    x=O(2)+data(2,kk)+(m-n)/2;
    if data(4,kk)~=0
        points(1,data(4,kk))=x;
        points(2,data(4,kk))=y;
    end
    newImage(y,x)=data(1,kk);
    newImage(y-1,x)=data(1,kk);
    newImage(y+1,x)=data(1,kk);
    newImage(y,x-1)=data(1,kk);
    newImage(y,x+1)=data(1,kk);
end
[Fr,Fc]=find(newImage>0,1,'first');
[Lr,Lc]=find(newImage>0,1,'last');
newImage=double(newImage(Fr:Lr,Fc:Lc));
points(1,:)=points(1,:)-Fc;
points(2,:)=points(2,:)-Fr;
points
end

function [points,newImage]=ScalingMatrix(img,X,Y,points)
img=double(img);
m=size(img,1);n=size(img,2);
%藉由放大倍率即可得新的圖片維度
M=ceil(Y*m);N=ceil(X*n);
O=round([m n]./2); %O(y,x) 同樣地定義圖片中心為原點
newImage=zeros(M,N);
count=1;
data=zeros(4,400000);
for ii = 1:size(img,1)
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        x=jj-O(2);y=O(1)-ii;
        [~,loc_1]=find(ii==round(points(2,:)));
        [~,loc_2]=find(jj==round(points(1,:)));
        if ~isempty(loc_1) && ~isempty(loc_2)
            loc=sum(ismember(loc_1,loc_2).*loc_1);  
            data(:,count)=[img(ii,jj);x;y;loc];
        else
            data(:,count)=[img(ii,jj);x;y;0];
        end
        count=count+1;
    end
end
%scaling
S=[X 0;0 Y];
data(2:3,:)=round(S*data(2:3,:));
last=find(data(1,:)~=0,1,'last');
for kk = 1:last
        
    y=O(1)-data(3,kk)+round((M-m)/2);
    x=O(2)+data(2,kk)+round((N-n)/2);
    if data(4,kk)~=0
        points(1,data(4,kk))=x;
        points(2,data(4,kk))=y;
    end
    newImage(y,x)=data(1,kk);
    if y>1 && x>1
        newImage(y-1,x)=data(1,kk);
        newImage(y+1,x)=data(1,kk);
        newImage(y,x-1)=data(1,kk);
        newImage(y,x+1)=data(1,kk);
    end
end
[Fr,Fc]=find(newImage>0,1,'first');
[Lr,Lc]=find(newImage>0,1,'last');
newImage=double(newImage(Fr:Lr,Fc:Lc));
points(1,:)=points(1,:)-Fc;
points(2,:)=points(2,:)-Fr;
points
end
function newImage=CombinateImg(img,img_1,points)
[r,c]=size(img);
[r_1,c_1]=size(img_1);
m=r+r_1;
n=c+c_1;
%計算新圖片的維度最保險的方法就是兩張圖片維度相加
newImage=zeros(m,n);
newImage(1:r,1:c)=img;
%計算處理完的圖片要平移到何處，藉由我們的points與標籤可以輕鬆得到相對位置
dx=abs(round(mean(points(1,:)-points(3,:))));
dy=abs(round(mean(points(2,:)-points(4,:))));
newImage(dy:dy+r_1-1,dx:dx+c_1-1)=img_1;
end