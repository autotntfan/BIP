clear;
close all;
files={'HW8_fix.mat','HW8_warp.mat','HW8_Irad.mat','HW8_Itof.mat',"BIP_HW8_points.mat"};
for ii=1:numel(files)
    load(files{ii});
end
figure,imshow(I1,[]);
% question 1 pictures�GI1�BI2warp
% POI:getpts   ROI:roipoly(img) �䤤getpts�w�qx�������V�k��V y�������V�U��V
% ����K���եΡA�@�~��ܪ��I�w�ϥΨ��'savepoint'�s�J'BIP_HW8_points.mat'��Ū��
% % SavePoint(I2warp,I1);
points=HW8_points
data=VectorData(points);
%�p�������F�X�סA�d�ݤF���Y���Ƥj�����O1���]���������F����Mshearing
%��max�Ӥ���mean�O�]��max�B�z�_�Ӥ���������|�n�n���A���M�u�t�F1�B2�ץi��O�߲z�@��
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
%�Ĥ@�զV�q ���� �ù��W���I�ܿù��k�W��
vector1_tilt=[points(1,2)-points(1,1),points(2,2)-points(2,1)];
vector1=[points(3,2)-points(3,1),points(4,2)-points(4,1)];
%�ĤG�զV�q ���� �ù��U���I�ܿù��k�U��
vector2_tilt=[points(1,6)-points(1,5),points(2,6)-points(2,5)];
vector2=[points(3,6)-points(3,5),points(4,6)-points(4,5)];
%�ĤT�զV�q ���� ���إ��I�ܵ��إk�I
vector3_tilt=[points(1,8)-points(1,7),points(2,8)-points(2,7)];
vector3=[points(3,8)-points(3,7),points(4,8)-points(4,7)];
%�ĥ|�զV�q ���� �ѥ����W���ܮѥ��k�W��
vector4_tilt=[points(1,10)-points(1,9),points(2,10)-points(2,9)];
vector4=[points(3,10)-points(3,9),points(4,10)-points(4,9)];
%�Ĥ��զV�q ���� �ù����W�I�ܿù����U�I
vector5_tilt=[points(1,5)-points(1,1),points(2,5)-points(2,1)];
vector5=[points(3,5)-points(3,1),points(4,5)-points(4,1)];
%�Ĥ��զV�q ���� �ù��k�W���ܿù��k�U��
vector6_tilt=[points(1,6)-points(1,2),points(2,6)-points(2,2)];
vector6=[points(3,6)-points(3,2),points(4,6)-points(4,2)];
%�ĤC�զV�q ���� ��î���I�ܵ�î�U��
vector7_tilt=[points(1,7)-points(1,3),points(2,7)-points(2,3)];
vector7=[points(3,7)-points(3,3),points(4,7)-points(4,3)];
%�ĤK�զV�q ���� ���ؤ��I�ܵ��ؤU��
vector8_tilt=[points(1,8)-points(1,4),points(2,8)-points(2,4)];
vector8=[points(3,8)-points(3,4),points(4,8)-points(4,4)];

%data:�Ĥ@�C(row)�����Y���� �ĤG�C(row)������
data=zeros(2,8);
for ii = 1:8
    [data(1,ii),data(2,ii)]=Vtheta(eval(['vector' num2str(ii) '_tilt']),eval(['vector' num2str(ii)]));
end

end

function SavePoint(img1,img2)
% ��M10���I�A���O��4�ի�������u�P4�դ�������u:
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
%�p��V�q�����P�������Y
    theta=acos(dot(u,v)/(sqrt(dot(u,u))*sqrt(dot(v,v))))*180/pi;
    scale=sqrt(dot(u,u))/sqrt(dot(v,v));
end

function newImage=RotatePolar(img,rot)
img=double(img);
[m,n]=size(img);
O=round([m n]./2); %O(y,x)
%���F�������^�h�ɨS�a��񹳯��A�N�Ϥ������X�i��max(m,n)�A���O����k�L�k�A�Ω���ਤ�׹L�p���Ϥ�
%���n����k�ثe�Q��O���Q���઺�Ϥ��﨤�u���סA���O�n����﨤�u���׳o�Ӹ�T�ݭn�i���B�~���B�z
newImage=zeros(max([m,n]));
%�q�`�ڤ��|���D�v����ڦ��h�֭�Pixels
%�]���b�x�s�����ӥ�list.append�������@�ӱ��ۤ@���x�s�i�h�Ӥ��O�]�w�i�H��N��pixels
%�ܥi��v���W�LN��Pixels�ӥX�{���~�A�����F�[�ֵ{���B��b���N�����]�w40�U�A��ڤW�u��30�X�U��
data=zeros(400000,3);
count=1;
%ii:y jj:x
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    %�w�q�Ϥ����߬����I�A�V�|�P�i�}�|�ӶH���A���׽d��0~360��
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
        %���ӭndata=[data;[img(ii,jj),dist,theta]]�~���T�A���ӺC�F
        data(count,:)=[img(ii,jj),dist,theta];
        count=count+1;
    end
end
%����
data(:,3)=data(:,3)+rot;  
%���򤣦s�b����ƴN���ΦA�B�z
last=find(data(:,1)~=0,1,'last');
for kk =1:last
    %�N���׽d�򭭨��0~360
    if data(kk,3)>360
        data(kk,3)=data(kk,3)-360;
    end
    deg=double(data(kk,3)*pi/180);
    %�ѩ�arctan�|���L�w�q�����p(�Ϥ����I�B)�A�]���J��ɿ�ܵL��
    if isnan(deg) 
        continue
    end
    %�]���˹Ϥ����e��dim=(m,m)�]���b������V�ݭn������
    x=O(2)+round(data(kk,2)*cos(deg))+(m-n)/2;
    y=O(1)-round(data(kk,2)*sin(deg));
    %�Y�O�Ȩϥ�newImage(y,x)=data(kk,1);�X�Ӫ��Ϧ]��round�t�G�|�ܦh�I�S����
    %�K�����߯g�o�@�ܤ��ΪA�A�]���令�H�U��ɯʤf
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
%�����Ϥ������I�P���I��@�x�sx.y��T���_�I�P���I
[Fr,Fc]=find(img~=0,1,'first');
[Lr,Lc]=find(img~=0,1,'last');
img=double(img);
[m,n]=size(img);
%�ѩ�Ϥ��H�\���A�{�b�ڭ̭n�M�w�s���Ϥ����׬��h�֡A�g�ѥH�U�X���ҥi��
%-------------------- ----  �Ϥ������ץi��m*sec(�������ਤ��)�ӱo
%��  theta�@\             \       ���ץi��n-x�ӱo�A�䤤x=m*tan(�������ਤ��)
% m  �@      \     �Ϥ�    \
%��  �@       \             \
%-----------------------------
%�@��  �A    ��
%  ��            n          ��
pdc_len=round(m*sec(theta*pi/180));
hrz_len=round(n-m*tan(theta*pi/180));
%�w�q�Ϥ����U�������I
O=[Lc-hrz_len,Lr];
%���F�[�ְj��B��A�]�w�`������40w��
data=zeros(400000,4);
%        (n-x) (0,m)
%----------------------------      �ǥ��[��ܩ��㪾�D�O����shearing�]���i��
%��       �@\   |           \       (x,y)->(x',y)���Y��x+ay=x'�ϱ�shearing�Y��a
% y  �@      \  |    �Ϥ�    \         a=(x'-x)/y
%��  �@       \ |             \
%              \|              \
%--------------------------------
%�@            O               ���A��V   
%  
S=(n-hrz_len)/m;
count=1;
%ii:y jj:x
for ii = 1:m
    %���n�x�s��C�@��row��0�A�ڥu�n���v���j�ת������I
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        %�B�z���ҡA�]���x�}�����쥻�е����Q�Ixy�ȷ|�]���A�]���ڻݭn�z�L���ҧ⥦��^��
        %�ì����L�Q����...���B�z�᪺�����m
        [~,loc_1]=find(ii==round(points(2,:)));
        [~,loc_2]=find(jj==round(points(1,:)));
        if ~isempty(loc_1) && ~isempty(loc_2)
            loc=sum(ismember(loc_1,loc_2).*loc_1);    
            %data�x�s�Fintensity�B�کw�q��x�y�ЭȡB�کw�q��y�y�ЭȡB����
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
    %�N�کw�q��x,y���ഫ��Matlab������row,column
    x=O(1)+data(kk,2);
    y=O(2)-data(kk,3);
    newImage(y,x)=data(kk,1);
    if data(kk,4)~=0
        %�N�Q����...���B�z�L���y�Ь����^points
        points(1,data(kk,4))=x;
        points(2,data(kk,4))=y;
    end
end
[Fr,Fc]=find(newImage>0,1,'first');
[Lr,Lc]=find(newImage>0,1,'last');
newImage=double(newImage(Fr:Lr,Fc:Lc));
%�ѩ�v���Q����F�A�]���y�лݭn�A�B�z�@��
points(1,:)=points(1,:)-Fc;
points(2,:)=points(2,:)-Fr;
points
end

function [points,newImage]=RotateMatrix(img,theta,points)
img=double(img);
[m,n]=size(img);
O=round([m n]./2); %O(y,x) �w�q��J�Ϥ��������߬����I�A�y�жb�ѭ��I�V�|�P�i�}
%�w�qx.y
%        y
%        ��
%        �U
%---------o---------�� x
%        �U
%        �U
newImage=zeros(max([m,n]));
count=1;
data=zeros(4,400000);
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        %�ഫ���کw�q��x.y�y�Э�
        x=jj-O(2);y=O(1)-ii;
        
        [~,loc_1]=find(ii==round(points(2,:)));
        [~,loc_2]=find(jj==round(points(1,:)));
        if ~isempty(loc_1) && ~isempty(loc_2)
            %�ӤJ����
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
    %��^Matlab��row,column    
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
%�ǥѩ�j���v�Y�i�o�s���Ϥ�����
M=ceil(Y*m);N=ceil(X*n);
O=round([m n]./2); %O(y,x) �P�˦a�w�q�Ϥ����߬����I
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
%�p��s�Ϥ������׳̫O�I����k�N�O��i�Ϥ����׬ۥ[
newImage=zeros(m,n);
newImage(1:r,1:c)=img;
%�p��B�z�����Ϥ��n�������B�A�ǥѧڭ̪�points�P���ҥi�H���P�o��۹��m
dx=abs(round(mean(points(1,:)-points(3,:))));
dy=abs(round(mean(points(2,:)-points(4,:))));
newImage(dy:dy+r_1-1,dx:dx+c_1-1)=img_1;
end