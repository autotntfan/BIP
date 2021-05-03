% [a_T,b_T,c_T]=ParabolicHoughTransform(X,UL)
% The function is used to check whether or not three points you selected
% lie on a parabola,straightline,same point,or they can't even be expressed 
% in standard parabola equation. 
% 
% Standard parabola equation : y=ax^2+bx+c ,where a、b、c are unknown
% We only know three points X=(X1,X2,X3)
%
% ParabolicHoughTransform(X,UL)
% The function will emerge a number of figures in order including 
% 1. mapping 3 pairs (x,y) to the hough space spanned by (a,0,0),(0,b,0),(0,0,c);
%    i.e. (x,y)=>T=>(a,b,c), R^2 => R^3 
% 3. the last figure represents all of the mapping results in abc space.
% 4. if they are collinear,then print the function,otherwise,print "They can't form a parabola"
% Xi=[xi  yi] is the point you wanna check that,xi and yi are double or int.
% Alert:The curve may be approximate if a or b is too small,
%
% a_T,b_T,c_T is a (slightly) exact solution for c=y-ax^2-bx to help you 
% check if the solution is exact or approximate.
%
% for example      
%       ParabolicHoughTransform([2,-3,3;1,4,17],[10,10])
%       check what (x,y)=[2,1],[-3,4],[3,17] map to
%       ,and if the points are on a parabola.
%       ans = 'y=2.77x^2+2.17x+-14.42' (approximately)
%
%       ParabolicHoughTransform([1,2,3;2,4,6],[10,10])
%       ans = 'y=0.00x^2+2.00x+0.00',Three points are on a straightline.
%                                                                           @2020.11.15 02:50
% 新增限制區域UL解決找不到解問題，加入解三元一次方程式算出正確的abc值，若超出UL則提示更改區域
% 解決無限小數與a.b過小的問題
%                                                                           @2020.11.16 00:35
% 增加輸出參數值[A_T,B_T,C_T]提供確認匯出的二次曲線是否為一個近似曲線，若A_T,B_T,C_T是非常小的值
% 此曲線是一個近似值，且這三個點因精度問題無法形成一個完美的二次曲線甚至是不存在
%                                                                           @2020.11.16 22:14

function [A_T,B_T,C_T]=ParabolicHoughTransform(X,UL)
%     % y=ax^2+bx+c 
%     if nargin < 2
%         error('Not enough input arguments.You need to decide x-y range')
%         return
%     end
    figure(1);
    X=round(X,1);
    x=[X(1,1) X(1,2) X(1,3)];
    y=[X(2,1) X(2,2) X(2,3)];
    plot(x,y,'r*'); %這些點長甚麼樣子

    a_x=(UL(1)-20):0.01:UL(1);b_y=(UL(2)-20):0.01:UL(2); %abc空間坐標軸顯示長度
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
    %非常重要且困難的問題，由於取樣精度使得13/6這種無限小數無法找到座標，因此不能直接設定
    %E_1=(cc2-cc1)==0;這樣必定出現無交集，cc2-cc1可能是負值，因此需加絕對值，我們取樣精度到
    %小數點後兩位，因此設定差值若小於0.1就當作他們相同，但這會使結果abc為近似值
    %例如y=x^2會顯示y=0.99x^2+0.03x-0.02
    %因此解決辦法：先用abs(cc2-cc1)<1e-10過濾無限小數或a.b是<0.01的值，因為正常的情況減出來都是0
    %若是遇到無限小數或很小的a.b，則差值會很小，可能為0.007之類的，需透過第二層篩檢
    %無法使用min判斷double格式最小值位置
    
    E_1=abs(cc2-cc1)<1e-10;
    E_2=abs(cc3-cc1)<1e-10;
    E_3=abs(cc3-cc2)<1e-10;
    %此處僅討論是否原本由y=ax^2+bx+c轉換 a絕對不能為0不然%^&%&$#很複雜不想討論那麼多情況
    %簡單講就是不討論原本是直線的狀況 反正任兩點一定是直線
    %因此判斷式三種情況都要討論 即三組兩者點乘中不能有一組以上為0矩陣 必須全為不為0矩陣
    %ex E_n=[0 1 0] [0 1 0] [0 1 0] 符合點乘全部非0矩陣，因此可以找到一個三平面交點
    %ex E_n=[0 0 1] [0 1 0] [0 1 0] E_1與其他矩陣點乘會出現0矩陣 則找不到交點
    %if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
    %      ......not found
    %
    %找到確切值
    T=[X(1,1)^2 X(1,1) 1;X(1,2)^2 X(1,2) 1;X(1,3)^2 X(1,3) 1]\[X(2,1);X(2,2);X(2,3)];
    a_T=T(1);b_T=T(2);c_T=T(3);
    if nargout >0
        A_T=vpa(a_T);
        B_T=vpa(b_T);
        C_T=vpa(c_T);
    end
    %確認E_1.*E_2.*E_3 若all(Check(:))==1表三平面交於同一平面
    %若Check==1表示某個位置三個矩陣值都相同
    Check=E_1.*E_2.*E_3;
    if all(Check(:))==1
        figure;
        plot(x,y,'r*');
        title(sprintf('They are the same point (%.2f,%.2f)',x(1),y(1)));
        return
    else
        [m,n]=find(Check==1,1,'first');
    end
    
    %如果m找不到，可能是
    %1. a or b超出選的範圍 因此出現error
    %2. 無限小數在搞事
    if isempty(m)
        if (abs(a_T-(UL(1)-10))>=10)  
        xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
        msg = sprintf("a is out of range.You have to change the parameter 'UL',%.2f<UL(1)<%.2f.",(a_T+1),(a_T+19));
        error(msg)
        return
        end
        if (abs(b_T-(UL(2)-10))>=10)
            xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
            msg = sprintf("b is out of range.You have to change the parameter 'UL',%.2f<UL(2)<%.2f.",(b_T+1),(b_T+19));
            error(msg)
            return
        end
        
        E_1=abs(cc2-cc1)<0.02;
        E_2=abs(cc3-cc1)<0.02;
        E_3=abs(cc3-cc2)<0.02;
        Check=E_1.*E_2.*E_3;
        [m,n]=find(Check==1,1,'first');
        if isempty(m)
            msg = sprintf("They can't form a parabola");
            error(msg);
            return
        end
            
    end
    a=aa(m,n);b=bb(m,n);c=cc1(m,n);    
    if (abs(a-(UL(1)-10))==10)  
        xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
        msg = sprintf("a is out of range.You have to change the parameter 'UL',%.2f<UL(1)<%.2f.",(a_T+1),(a_T+19));
        error(msg)
        return
    end
    if (abs(b-(UL(2)-10))==10)
        xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
        msg = sprintf("b is out of range.You have to change the parameter 'UL',%.2f<UL(2)<%.2f.",(b_T+1),(b_T+19));
        error(msg)
        return
    end
    xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('Interaction point=(%.2f,%.2f,%.2f)',aa(m,n),bb(m,n),cc1(m,n)));
    sprintf('The parameters are a=%.2f b=%.2f c=%.2f\n',a,b,c)
    sprintf('y=%.2fx^2+%.2fx+%.2f',a,b,c)
    figure;
    xxx=-100:100;
    yyy=a*xxx.^2+b*xxx+c;
    plot(xxx,yyy);
    hold on;
    plot(x,y,'r*');
    title(sprintf('y=%.2fx^2+%.2fx+%.2f',a,b,c));
end



        





