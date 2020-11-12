clear;
close all;
load HW7_T1brain.mat;
img=T1brain;
imshow(img,[]);
%normalize
[m,n]=size(img);
%%% �~��max�ɪ��Q�k�ϥ�"%%%"���ѻ���
%%% NM_img=double(img)./double(max(img(:,:)));

NM_img=double(img)./double(max(img(:)));
NM_img(isnan(NM_img)==1)=0;
%-----------------------------------problem(a)-----------------------------------

%threshold=0.356 sigma=0.537(��for�d��threshold=0.01~0.99�Psigma=0~1���ĪG�A�M�w�ƭ�)
img_1=edge(img,'Canny',0.356,0.537);
figure,imshow(img_1);
xlabel('Canny detection')
%-----------------------------------problem(b)-----------------------------------
%find threshold
[LEVEL, EM]=graythresh(NM_img);
%�d��LEVEL�BEM���G�ȤƳB�z�᪺�ĪG�p��


%%%%%%%%%%%%%%%%%%%%%%%%���Ϭ��[��histogram��H�u�]�w�֭�T1�PT2%%%%%%%%%%%%%%%%%%%%%%%%
% LEVEL=150/629;                                                                     %
% EM=350/629;                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Binary_img_T1 = imbinarize(NM_img,LEVEL);
figure,imshow(Binary_img_T1);
xlabel(['Threshold1 =',num2str(LEVEL)]);
%%% T1=LEVEL=0.4039���X���ĪG�P�Q�������P �]��T1�Ӥp �X�G���զ� ���ӭn�A�B�z
%%% ���i�W�g��0.04039���~�� �]��ɨϥ�xlabel('Threshold1 = 0.04039");


Binary_img_T2 = imbinarize(NM_img,EM);
figure,imshow(Binary_img_T2);
xlabel(['WM Threshold2 =',num2str(EM)]);
%%% T2=EM=0.7964���Ϭݰ_�ӹ��O�ս賡�� �q���Ѿl��T1~T2�϶����O�ǽ賡��
%%% �H�U�M��ǽ� �]���G�Ϥ����O�G�Ȥ� �]���Ыعs�x�}��N�ŦXT1~T2���ƭȦ�m�]��1

Binary_img_T1=zeros(m,n);
for ii=1:256
    for jj=1:224
        if NM_img(ii,jj)>LEVEL && NM_img(ii,jj)<EM
            Binary_img_T1(ii,jj)=NM_img(ii,jj);
        end
    end
end
%%% �䦨�G�ϽT��O�ǽ賡�� 
% �令 NM_img=double(img)./double(max(img(:)));��ұo���ϩM��Ϫ��o�t���h
% �]���ڥ��S�����A�X���֭�
figure,imshow(Binary_img_T1);
xlabel(['GM Threshold2 =',num2str(EM)]);
%-----------------------------------problem(c)-----------------------------------
% �ϥ�QQQTTT�o�Ө�ƴM��A�X�����Τj�p
% NM_img�G���W�ƫ᪺�Ϥ�
% �������μ�:xx �������μ�:yy xx�ݬ�256�]�� yy�ݬ�224�]��
% �Y�n��kernel=k*k �hxx=m/k yy=n/k
% e.g. kernel size=4 xx=256/4=64 yy=224/4=56

xx=4;
yy=4;
% QQQTTT�|�L�X�T�i�Ϥ��G�¦ⳡ�� �ս� �ǽ�
QQQTTT(NM_img,xx,yy);

%��k-mean cluster������
kmean_img=imsegkmeans(img,3);
Black=NM_img.*double(kmean_img==1);
WM=NM_img.*double(kmean_img==2);
GM=NM_img.*double(kmean_img==3);

figure,imshow(Black);
xlabel('block region');
figure,imshow(WM);
xlabel('WM')
figure,imshow(GM);
xlabel('GM');


function QQQTTT(NM_img,xx,yy)
% Matrix_N
% 1 | 2 |  3  | 4 ....
%-------------------
% 5 | 6  | 7  | 8 ....
%-------------------
% 9 | 10 | 11 | 12 ....
% ------------------
% . |  . | .  | .
%
[m,n]=size(NM_img);
T=zeros(2,xx*yy);
Binary_img_T1=zeros(m,n);
Binary_img_T2=zeros(m,n);
Binary_img_T1toT2=zeros(m,n);

for ii=1:xx
    for jj=1:yy
        x1=(ii-1)*m/xx+1;
        x2=ii*m/xx;
        y1=(jj-1)*n/yy+1;
        y2=jj*n/yy;
        Num=(ii-1)*xx+jj;
        matrix=NM_img(x1:x2,y1:y2);
        %�ΥH�d�ݨC�Ӥ��ιϤ���histogram�H�T�{�֭Ȫ���ܬO���A�X
        %figure,histogram(matrix)
        [t1,t2]=graythresh(matrix);
        T(1:2,Num)=[t1;t2];
        %�Yt1�L�p �]�w�@�ӳ̧C�� �L�o�v���j�׫ܤp���a��
        if t1<0.15 
            t1=0.15
            Binary_img_T1(x1:x2,y1:y2) =imbinarize(matrix,t1);   
            Binary_img_T2toT1(x1:x2,y1:y2)=imbinarize(matrix,t1);
        %�[��histogram�o�{�ܦh�ڥ��S���ȶW�L0.7 �]���Nt2�B�z�@�U
        elseif t2>0.8
            t2=t2-t1;
            Binary_img_T1(x1:x2,y1:y2)=imbinarize(matrix,t1);
            Binary_img_T2(x1:x2,y1:y2) =imbinarize(matrix,t2); 
            for iii=1:m/xx
                for jjj=1:n/yy
                    if (t1<matrix(iii,jjj)) && (matrix(iii,jjj)<t2)
                        Binary_img_T1toT2(x1+iii-1,y1+jjj-1)=NM_img(x1+iii-1,y1+jjj-1);
                    end
                end
            end
        else                      
            Binary_img_T1(x1:x2,y1:y2) =imbinarize(matrix,t1);
            Binary_img_T2(x1:x2,y1:y2) = imbinarize(matrix,t2);
            for iii=1:m/xx
                for jjj=1:n/yy
                    if (t1<matrix(iii,jjj)) && (matrix(iii,jjj)<t2)
                        Binary_img_T1toT2(x1+iii-1,y1+jjj-1)=NM_img(x1+iii-1,y1+jjj-1);
                    end
                end
             end
        end
%         �o��O�Ψ��ˬd����ɬO�_����T �|�N��������s�Jmatrix_N��
%         Value=NM_img(x1:x2,y1:y2);
%         eval(['matrix_' num2str(Num) '=Value;']);
%         [t1,t2]=graythresh(eval(['matrix_' num2str(Num)]));
%         T(1,Num)=t1;
%         T(2,Num)=t2;
%         Binary_img_T1(x1:x2,y1:y2) = imbinarize(eval(['matrix_' num2str(Num)]),t1);
%         Binary_img_T2(x1:x2,y1:y2) = imbinarize(eval(['matrix_' num2str(Num)]),t2);
% 
%         for iii=1:m/xx
%             for jjj=1:n/yy
%                 if (t1<eval(['matrix_' num2str(Num) '(iii,jjj)'])) && (eval(['matrix_' num2str(Num) '(iii,jjj)'])<t2)    
%                     Binary_img_T1toT2(x1+iii-1,y1+jjj-1)=NM_img(x1+iii-1,y1+jjj-1); 
%                     
%                  end
%             end
%         end
    end
end

figure,imshow(Binary_img_T1,[]);
figure,imshow(Binary_img_T2,[]);
figure,imshow(Binary_img_T1toT2,[]);
end