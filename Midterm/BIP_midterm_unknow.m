close all;
clear;
% The function is used to find the parameters determined by selected points.
% Alert:The function can NOT be used to do including infinite decimal
% parameters.For example y=5x^2+13*x/6-1,where 13/6 is a infinite decimal.
% If unfortunately input a infinite decimal,the result must be
% "noncollinear".
% parabola : y=ax^2+bx+c ,where a、b、c are unknown,we only know three points
% and wanna check the parameters.
% HoughTransform(X1,X2,X3) 
% the function will emerge a number of figures in order including 
% 1. mapping 3 pairs (x,y) to the hough space spanned by (a,0,0),(0,b,0),(0,0,c);
%    i.e. (x,y)=>T=>(a,b,c), R^2 => R^3 
% 3. the last figure represents all of the mapping results in abc space.
% 4. if they are collinear,then print the function,otherwise,print
% "noncollinear"
% However,distinct three points in R^2 space can be connected with each other exactly.
%
% Xi=[xi  yi] is the point you wanna check that.
% 
% for example      
%       HoughTransform([2,1],[-3,4],[3,16])
%       check what (x,y)=[2,1],[-3,4],[3,16] map to
%       ,and if the points are on a parabola.
%       ans = "points are noncollinear"
%       

%p.18
HoughTransform([1,3],[2,7],[-4,13])
%p.19
%HoughTransform([2,1],[-3,4],[3,17])

function HoughTransform(X1,X2,X3)
% y=ax^2+bx+c 
figure(1);

x=[X1(1) X2(1) X3(1)];
y=[X1(2) X2(2) X3(2)];
plot(x,y,'r*'); %這些點長甚麼樣子

a_x=-10:0.1:10;b_y=-10:0.1:10; %abc空間坐標軸顯示長度
[aa,bb]=meshgrid(a_x,b_y);
C=["r","g","b"];

for kk=1:length(x)
    xx=x(kk);yy=y(kk);
    % 計算Z值
    cc=yy-aa.*(xx^2)-bb.*xx;
    % 為方便後續作圖 將Z值存入cc_n 
    eval(['cc' num2str(kk) '=cc;'])
    %將每個x,y轉換到abc空間的圖畫出
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

%檢查平面是否有交集 使用方法：兩矩陣相減-0處則表示值相同
%相同值的位置輸出1,否則0,若兩個沒有交點/線，輸出會全0 因此兩矩陣點乘=O
E_1=(cc2-cc1)==0;
E_2=(cc3-cc1)==0;
E_3=(cc3-cc2)==0;
%此處僅討論是否原本由y=ax^2+bx+c轉換 a絕對不能為0不然%^&%&$#很複雜不想討論那麼多情況
%簡單講就是不討論原本是直線的狀況 反正任兩點一定是直線
%因此判斷式三種情況都要討論 即三組兩者點乘中不能有一組以上為0矩陣 必須全為不為0矩陣
%ex E_n=[0 1 0] [0 1 0] [0 1 0] 符合點乘全部非0矩陣
%ex E_n=[0 0 1] [0 1 0] [0 1 0] E_1與其他矩陣點乘會出現0矩陣 則if必成立
if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
    sprintf("points are noncollinear")
    xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
else
    [m,n]=find((E_1.*E_2)==1);
    if aa(m,n)==10 | bb(m,n)==10
        sprintf('out of range');
    else
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
end

        





