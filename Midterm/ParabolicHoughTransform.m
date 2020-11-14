
% The function is used to check if three points are collinear
% Alarm:The function can ONLY be used to do when 10>a>-10 and 10>b>-10
% standard parabola equation : y=ax^2+bx+c ,where a�Bb�Bc are unknown
% we only know three points and wanna check if they are collinear.
% HoughTransform(X1,X2,X3): 
% the function will emerge a number of figures in order including 
% 1. mapping 3 pairs (x,y) to the hough space spanned by (a,0,0),(0,b,0),(0,0,c);
%    i.e. (x,y)=>T=>(a,b,c), R^2 => R^3 
% 3. the last figure represents all of the mapping results in abc space.
% 4. if they are collinear,then print the function,otherwise,print "points are noncollinear"
% Xi=[xi  yi] is the point you wanna check that,xi and yi are double or int.
% the curve may be approximate,X1=[1,2].
% for example      
%       ParabolicHoughTransform([2,1],[-3,4],[3,16])
%       check what (x,y)=[2,1],[-3,4],[3,16] map to
%       ,and if the points are on a parabola.
%       ans = "points are noncollinear"
%       The curve may be approximate as three points are on the unique straightline,
%       i.e.X1=[1,2].X2=[2,4],X3=[3,6]
%                                                                           @2020.11.15 02:50

function ParabolicHoughTransform(X1,X2,X3)
    % y=ax^2+bx+c 

    figure(1);

    x=[X1(1) X2(1) X3(1)];
    y=[X1(2) X2(2) X3(2)];
    plot(x,y,'r*'); %�o���I���ƻ�ˤl

    a_x=-10:0.01:10;b_y=-10:0.01:10; %abc�Ŷ����жb��ܪ���
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

    %�ˬd�����O�_���涰 �ϥΤ�k�G��x�}�۴�-0�B�h��ܭȬۦP
    %�ۦP�Ȫ���m��X1,�_�h0,�Y��ӨS�����I/�u�A��X�|��0 �]����x�}�I��=O
    %�D�`���n�����D�A�ѩ���˺�רϱo13/6�o�صL���p�ƵL�k���y�СA�]�����ઽ���]�w
    %E_1=(cc2-cc1)==0;�o�˥��w�X�{�L�涰
    %�L�k�ϥ�min�P�_double�榡�̤p�Ȧ�m
    E_1=(cc2-cc1)<1e-200;
    E_2=(cc3-cc1)<1e-200;
    E_3=(cc3-cc2)<1e-200;
    %���B�ȰQ�׬O�_�쥻��y=ax^2+bx+c�ഫ a���藍�ର0���M%^&%&$#�ܽ������Q�Q�ר���h���p
    %²�����N�O���Q�׭쥻�O���u�����p �ϥ������I�@�w�O���u
    %�]���P�_���T�ر��p���n�Q�� �Y�T�ը���I�������঳�@�եH�W��0�x�} ������������0�x�}
    %ex E_n=[0 1 0] [0 1 0] [0 1 0] �ŦX�I�������D0�x�}
    %ex E_n=[0 0 1] [0 1 0] [0 1 0] E_1�P��L�x�}�I���|�X�{0�x�} �hif������
    if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
        sprintf("points are noncollinear")
        xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('404 not found'));
    else
        [m,n]=find((E_1.*E_2.*E_3)==1,1,'first');
       
        xlabel('a'),ylabel('b'),zlabel('c');title(sprintf('Interaction point=(%.2f,%.2f,%.2f)',aa(m,n),bb(m,n),cc1(m,n)));
        sprintf('The parameters are a=%.2f b=%.2f c=%.2f\n',aa(m,n),bb(m,n),cc1(m,n))
        sprintf('y=%.2fx^2+%.2fx+%.2f',aa(m,n),bb(m,n),cc1(m,n))
        figure;
        xxx=-10:10;
        yyy=aa(m,n)*xxx.^2+bb(m,n)*xxx+cc1(m,n);
        plot(xxx,yyy);
        hold on;
        plot(x,y,'r*');
        title(sprintf('y=%.2fx^2+%.2fx+%.2f',aa(m,n),bb(m,n),cc1(m,n)));
        if (abs(aa(m,n))==10) | (abs(bb(m,n))==10)
            sprintf('out of range,three points may be on the straightline or a point')
        end
    end
end


        





