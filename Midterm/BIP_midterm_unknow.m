close all;
clear;
% �ȥΨӬd�ݿ�J���T�I�O�_��@�u
% parabola : y=ax^2+bx+c ,where a�Bb�Bc are unknown,we only know three points
% and wanna check if they are collinear.
% HoughTransform(X1,X2,X3) 
% the function will emerge a number of figures in order including 
% 1. mapping 3 pairs (x,y) to the hough space spanned by (a,0,0),(0,b,0),(0,0,c);
%    e.g. (x,y)=>T=>(a,b,c), R^2 => R^3 
% 3. the last figure represents all of the mapping results in abc space.
% 4. if they are collinear,then print the function,otherwise,print
% "noncollinear"
%
% Xi=[xi  yi] is the point you wanna check that.
% 
% for example      
%       HoughTransform([2,1],[-3,4],[3,16])
%       check what (x,y)=[2,1],[-3,4],[3,16] map to
%       ,and if the points are on a parabola.
%       ans = "points are noncollinear"
%       

HoughTransform([1,3],[2,7],[-4,13])
function HoughTransform(X1,X2,X3)
% y=ax^2+bx+c 
figure(1);

x=[X1(1) X2(1) X3(1)];
y=[X1(2) X2(2) X3(2)];
plot(x,y,'r*'); %�o���I���ƻ�ˤl

a_x=-5:5;b_y=-5:5; %abc�Ŷ����жb��ܪ���
[aa,bb]=meshgrid(a_x,b_y);
C=["r","g","b"];

for kk=1:length(x)
    xx=x(kk);yy=y(kk);
    % �p��Z��
    cc=yy-aa.*(xx^2)-bb.*xx;
    % ����K����@�� �NZ�Ȧs�Jcc_n 
    eval(['cc' num2str(kk) '=cc;'])
    %�N�C��x,y�ഫ��abc�Ŷ����ϵe�X
    figure(1+kk);
    F1=mesh(aa,bb,cc);
    xlabel('a'),ylabel('b'),zlabel('c');titleStr=sprintf('Transform (x,y)=(%.2f,%.2f) into abc coord.',xx,yy); title(titleStr);
    set(F1,'EdgeColor',C(kk),'FaceColor',C(kk),'MarkerEdgecolor',C(kk),'MarkerFacecolor',C(kk));
end
figure;
F1=mesh(aa,bb,cc1);
set(F1,'EdgeColor','r','FaceColor','r','MarkerEdgecolor','r','MarkerFacecolor','r');
hold on
F2=mesh(aa,bb,cc2);
set(F2,'EdgeColor','g','FaceColor','g','MarkerEdgecolor','g','MarkerFacecolor','g');
hold on
F3=mesh(aa,bb,cc3);
set(F3,'EdgeColor','b','FaceColor','b','MarkerEdgecolor','b','MarkerFacecolor','b');

%�ˬd�����O�_���涰 �ϥΤ�k�G��x�}�۴�-0�B�h���ܭȬۦP
%�ۦP�Ȫ���m��X1,�_�h0,�Y��ӨS�����I/�u�A��X�|��0 �]����x�}�I��=O
E_1=(cc2-cc1)==0;
E_2=(cc3-cc1)==0;
E_3=(cc3-cc2)==0;
%���B�ȰQ�׬O�_�쥻��y=ax^2+bx+c�ഫ a���藍�ର0���M%^&%&$#�ܽ������Q�Q�ר���h���p
%²�����N�O���Q�׭쥻�O���u�����p �ϥ������I�@�w�O���u
%�]���P�_���T�ر��p���n�Q�� �ӥB���n�ŦX�I��=1 
%�Y�T�ը���I�������঳�@�եH�W����0
if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
    sprintf("points are noncollinear")
    xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
else
    [m,n]=find((E_1.*E_2)==1);
    xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('Interaction point=(%.2f,%.2f,%.2f)',aa(m,n),bb(m,n),cc1(m,n)));
    sprintf('The parameters are a=%.f b=%.f c=%.f\n',aa(m,n),bb(m,n),cc1(m,n))
    sprintf('y=%.fx^2+%.fx+%.f',aa(m,n),bb(m,n),cc1(m,n))
    figure;
    x=-10:10;
    y=aa(m,n)*x.^2+bb(m,n)*x+cc1(m,n);
    plot(x,y);
    title(sprintf('y=%.fx^2+%.fx+%.f',aa(m,n),bb(m,n),cc1(m,n)));
end
end

        




