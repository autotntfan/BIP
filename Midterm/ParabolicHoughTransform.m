
% The function is used to check if three points are collinear
% standard parabola equation : y=ax^2+bx+c ,where a�Bb�Bc are unknown
% we only know three points X=(X1,X2,X3)
% ParabolicHoughTransform(X,UL)
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
% �s�W����ϰ�UL�ѨM�䤣��Ѱ��D�A�[�J�ѤT���@����{����X���T��abc�ȡA�Y�W�XUL�h���ܧ��ϰ�
% �ѨM�L���p�ư��D
%                                                                           @2020.11.15 15:48

function ParabolicHoughTransform(X,UL)
%     % y=ax^2+bx+c 
%     if nargin < 2
%         error('Not enough input arguments.You need to decide x-y range')
%         return
%     end
    figure(1);

    x=[X(1,1) X(1,2) X(1,3)];
    y=[X(2,1) X(2,2) X(2,3)];
    plot(x,y,'r*'); %�o���I���ƻ�ˤl

    a_x=(UL(1)-20):0.01:UL(1);b_y=(UL(2)-20):0.01:UL(2); %abc�Ŷ����жb��ܪ���
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
    %�D�`���n�B�x�������D�A�ѩ���˺�רϱo13/6�o�صL���p�ƵL�k���y�СA�]�����ઽ���]�w
    %E_1=(cc2-cc1)==0;�o�˥��w�X�{�L�涰�Acc2-cc1�i��O�t�ȡA�]���ݥ[����ȡA�ڭ̨��˺�ר�
    %�p���I����A�]���]�w�t�ȭY�p��0.1�N��@�L�̬ۦP�A���o�|�ϵ��Gabc�������
    %�Ҧpy=x^2�|���y=0.99x^2+0.03x-0.02
    %�L�k�ϥ�min�P�_double�榡�̤p�Ȧ�m
    
    E_1=abs(cc2-cc1)<1e-10;
        if isempty(E_1)
           E_1=abs(cc2-cc1)<0.02;
        end
    E_2=abs(cc3-cc1)<1e-10;
        if isempty(E_2)
           E_2=abs(cc3-cc1)<0.02;
        end
    E_3=abs(cc3-cc2)<1e-10;
        if isempty(E_3)
           E_3=abs(cc3-cc2)<0.02;
        end
    %���B�ȰQ�׬O�_�쥻��y=ax^2+bx+c�ഫ a���藍�ର0���M%^&%&$#�ܽ������Q�Q�ר���h���p
    %²�����N�O���Q�׭쥻�O���u�����p �ϥ������I�@�w�O���u
    %�]���P�_���T�ر��p���n�Q�� �Y�T�ը���I�������঳�@�եH�W��0�x�} ������������0�x�}
    %ex E_n=[0 1 0] [0 1 0] [0 1 0] �ŦX�I�������D0�x�}
    %ex E_n=[0 0 1] [0 1 0] [0 1 0] E_1�P��L�x�}�I���|�X�{0�x�} �hif������
    %if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
    %      ......not found
    %
    %���T����
    syms a b c
    [a_T,b_T,c_T]=solve(a*(X(1,1)^2)+b*X(1,1)+c==X(2,1),a*(X(1,2)^2)+b*X(1,2)+c==X(2,2),a*(X(1,3)^2)+b*X(1,3)+c==X(2,3));
    %�T�{E_1.*E_2.*E_3 �Yall(Check(:))==1��T�������P�@����
    %�YCheck==1��ܬY�Ӧ�m�T�ӯx�}�ȳ��ۦP
    Check=E_1.*E_2.*E_3;
    if all(Check(:))==1
        figure;
        plot(x,y,'r*');
        title(sprintf('They are the same point (%.2f,%.2f)',x(1),y(1)));
        return
    else
        [m,n]=find(Check==1,1,'first');
    end
    

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

    end
    a=aa(m,n),b=bb(m,n),c=cc1(m,n)    
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
    xxx=-10:10;
    yyy=a*xxx.^2+b*xxx+c;
    plot(xxx,yyy);
    hold on;
    plot(x,y,'r*');
    title(sprintf('y=%.2fx^2+%.2fx+%.2f',a,b,c));
end



        





