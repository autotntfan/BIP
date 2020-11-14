close all;
clear;
%僅用來查看原本已知曲線，未知點是否在同一曲線上，若要判斷三點是否形成曲線，使用另外一個檔案
% y=ax^2+bx+c 
% HoughTransform(a,b,c,X) 
% the function will emerge a number of figures in order including 
% 1. y=ax^2+bx+c 
% 2. mapping 3 pairs (x,y) to the hough space spanned by (a,0,0),(0,b,0),(0,0,c);
%    e.g. (x,y)=>T=>(a,b,c), R^2 => R^3 
% 3. the last figure represents all of the mapping results in abc space.
% default selecting points are x=[2 -2 -1],and y is determined by input parameters.Hence they must be collinear.
% X=[x  y] can be used to check if the point is collinear.
% 
% for example      
%       HoughTransform(1,0,0,[1 16])
%       check what x=[2,-2,-1] y=[4,4,1] maps to
%       ,and if the point:(x,y)=(1,16) is on the
%       parabola y=x^2 
%

HoughTransform(1,2,1)
function HoughTransform(a,b,c,X)
x=-10:10;
%y=ax^2+bx+c 
figure(1);
y=a*x.^2+b.*x+c;
%a=(y-bx-c)/x^2
%b=(y-ax^2-c)/x
%c=y-ax^2-bx
%check the original figure

plot(x,y);
switch nargin
    case 4
        hold on;
        plot(X(1),X(2),'o');
end
        
%for example,if a=1 b=2 c=1,y=(x-1)^2
%y=x^2+2x+1
%default setting x=[2 -2 -1],then sample points x=2 y=9;x=-2 y=1;x=-1 y=0

x=[2 -2 -1];
switch nargin
    case 3
        y=a*x.^2+b.*x+c;
    otherwise
        y=a*x.^2+b.*x+c;
        x=[x X(1)];
        y=[y X(2)];
end

a_x=-5:5;b_y=-5:5; %坐標軸長度
[aa,bb]=meshgrid(a_x,b_y);
C=["r","g","b","y"];

for kk=1:length(x)
    xx=x(kk);yy=y(kk);
    cc=yy-aa.*(xx^2)-bb.*xx;
    eval(['cc' num2str(kk) '=cc;'])
    figure(1+kk);
    F1=mesh(aa,bb,cc);
    xlabel('a'),ylabel('b'),zlabel('c');titleStr=sprintf('Transform (x,y)=(%.2f,%.2f) into abc coord.',xx,yy); title(titleStr);
    %set(F1,'EdgeColor',C(kk),'FaceColor',C(kk),'MarkerEdgecolor',C(kk),'MarkerFacecolor',C(kk));
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
xlabel('a'),ylabel('b'),zlabel('c');title('Transformation');

E_4=zeros(length(a_x),length(b_y));
if kk==4
    hold on;
    F4=mesh(aa,bb,cc4);
    set(F4,'EdgeColor','y','FaceColor','y','MarkerEdgecolor','y','MarkerFacecolor','y');
    E_4=(cc4-cc2)==0;
end

E_1=(cc3-cc2)==0;
E_2=(cc1-cc2)==0;
E_3=(cc3-cc1)==0;

switch nargin
    case 3
        if (E_1.*E_2==0)  | (E_3.*E_2==0) | (E_1.*E_3==0)
            sprintf("points are noncollinear")
        else
            [m,n]=find((E_1.*E_2)==1);
            sprintf('The parameters are a=%.f b=%.f c=%.f\n',aa(m,n),bb(m,n),cc1(m,n))
            sprintf('y=%.fx^2+%.fx+%.f',aa(m,n),bb(m,n),cc1(m,n))
        end
    case 4
        if (E_1.*E_2==0)  | (E_3.*E_2==0) | (E_1.*E_3==0)
            sprintf("points are noncollinear")
            
        else
            [m,n]=find((E_1.*E_2)==1);
            sprintf('The parameters are a=%.f b=%.f c=%.f\n',aa(m,n),bb(m,n),cc1(m,n))
            sprintf('y=%.fx^2+%.fx+%.f',aa(m,n),bb(m,n),cc1(m,n))
            if  (E_1.*E_4==0) & (E_3.*E_4==0) & (E_1.*E_4==0)
                sprintf('point (%.2f,%.2f) is noncollinear',X(1),X(2))
            else
                sprintf('point (%.2f,%.2f) is collinear',X(1),X(2))
            end
                
        end
end
        
end




