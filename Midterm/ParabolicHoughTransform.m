% [a_T,b_T,c_T]=ParabolicHoughTransform(X,UL)
% The function is used to check whether or not three points you selected
% lie on a parabola,straightline,same point,or they can't even be expressed 
% in standard parabola equation. 
% 
% Standard parabola equation : y=ax^2+bx+c ,where a�Bb�Bc are unknown
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
% �s�W����ϰ�UL�ѨM�䤣��Ѱ��D�A�[�J�ѤT���@����{����X���T��abc�ȡA�Y�W�XUL�h���ܧ��ϰ�
% �ѨM�L���p�ƻPa.b�L�p�����D
%                                                                           @2020.11.16 00:35
% �W�[��X�Ѽƭ�[A_T,B_T,C_T]���ѽT�{�ץX���G�����u�O�_���@�Ӫ�����u�A�YA_T,B_T,C_T�O�D�`�p����
% �����u�O�@�Ӫ���ȡA�B�o�T���I�]��װ��D�L�k�Φ��@�ӧ������G�����u�ƦܬO���s�b
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
    %�]���ѨM��k�G����abs(cc2-cc1)<1e-10�L�o�L���p�Ʃ�a.b�O<0.01���ȡA�]�����`�����p��X�ӳ��O0
    %�Y�O�J��L���p�ƩΫܤp��a.b�A�h�t�ȷ|�ܤp�A�i�ର0.007�������A�ݳz�L�ĤG�h�z��
    %�L�k�ϥ�min�P�_double�榡�̤p�Ȧ�m
    
    E_1=abs(cc2-cc1)<1e-10;
    E_2=abs(cc3-cc1)<1e-10;
    E_3=abs(cc3-cc2)<1e-10;
    %���B�ȰQ�׬O�_�쥻��y=ax^2+bx+c�ഫ a���藍�ର0���M%^&%&$#�ܽ������Q�Q�ר���h���p
    %²�����N�O���Q�׭쥻�O���u�����p �ϥ������I�@�w�O���u
    %�]���P�_���T�ر��p���n�Q�� �Y�T�ը���I�������঳�@�եH�W��0�x�} ������������0�x�}
    %ex E_n=[0 1 0] [0 1 0] [0 1 0] �ŦX�I�������D0�x�}�A�]���i�H���@�ӤT�������I
    %ex E_n=[0 0 1] [0 1 0] [0 1 0] E_1�P��L�x�}�I���|�X�{0�x�} �h�䤣����I
    %if (E_1.*E_2==0)  & (E_3.*E_2==0) & (E_1.*E_3==0)
    %      ......not found
    %
    %���T����
    T=[X(1,1)^2 X(1,1) 1;X(1,2)^2 X(1,2) 1;X(1,3)^2 X(1,3) 1]\[X(2,1);X(2,2);X(2,3)];
    a_T=T(1);b_T=T(2);c_T=T(3);
    if nargout >0
        A_T=vpa(a_T);
        B_T=vpa(b_T);
        C_T=vpa(c_T);
    end
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
    
    %�p�Gm�䤣��A�i��O
    %1. a or b�W�X�諸�d�� �]���X�{error
    %2. �L���p�Ʀb�d��
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



        





