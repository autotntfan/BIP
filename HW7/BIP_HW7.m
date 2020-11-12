clear;
close all;
load HW7_T1brain.mat;
img=T1brain;
imshow(img,[]);
%normalize
[m,n]=size(img);
%%% 誤用max時的想法使用"%%%"註解說明
%%% NM_img=double(img)./double(max(img(:,:)));

NM_img=double(img)./double(max(img(:)));
NM_img(isnan(NM_img)==1)=0;
%-----------------------------------problem(a)-----------------------------------

%threshold=0.356 sigma=0.537(用for查看threshold=0.01~0.99與sigma=0~1的效果再決定數值)
img_1=edge(img,'Canny',0.356,0.537);
figure,imshow(img_1);
xlabel('Canny detection')
%-----------------------------------problem(b)-----------------------------------
%find threshold
[LEVEL, EM]=graythresh(NM_img);
%查看LEVEL、EM做二值化處理後的效果如何


%%%%%%%%%%%%%%%%%%%%%%%%此區為觀察histogram後人工設定閥值T1與T2%%%%%%%%%%%%%%%%%%%%%%%%
% LEVEL=150/629;                                                                     %
% EM=350/629;                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Binary_img_T1 = imbinarize(NM_img,LEVEL);
figure,imshow(Binary_img_T1);
xlabel(['Threshold1 =',num2str(LEVEL)]);
%%% T1=LEVEL=0.4039做出的效果與想像中不同 因為T1太小 幾乎都白色 應該要再處理
%%% 報告上寫的0.04039為誤植 因當時使用xlabel('Threshold1 = 0.04039");


Binary_img_T2 = imbinarize(NM_img,EM);
figure,imshow(Binary_img_T2);
xlabel(['WM Threshold2 =',num2str(EM)]);
%%% T2=EM=0.7964的圖看起來像是白質部分 猜測剩餘的T1~T2區間應是灰質部分
%%% 以下尋找灰質 因成果圖片都是二值化 因此創建零矩陣後將符合T1~T2的數值位置設成1

Binary_img_T1=zeros(m,n);
for ii=1:256
    for jj=1:224
        if NM_img(ii,jj)>LEVEL && NM_img(ii,jj)<EM
            Binary_img_T1(ii,jj)=NM_img(ii,jj);
        end
    end
end
%%% 其成果圖確實是灰質部分 
% 改成 NM_img=double(img)./double(max(img(:)));後所得的圖和原圖長得差不多
% 因為根本沒有找到適合的閥值
figure,imshow(Binary_img_T1);
xlabel(['GM Threshold2 =',num2str(EM)]);
%-----------------------------------problem(c)-----------------------------------
% 使用QQQTTT這個函數尋找適合的切割大小
% NM_img：正規化後的圖片
% 垂直切割數:xx 水平切割數:yy xx需為256因數 yy需為224因數
% 若要使kernel=k*k 則xx=m/k yy=n/k
% e.g. kernel size=4 xx=256/4=64 yy=224/4=56

xx=4;
yy=4;
% QQQTTT會印出三張圖片：黑色部分 白質 灰質
QQQTTT(NM_img,xx,yy);

%用k-mean cluster的概念
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
        %用以查看每個分割圖片的histogram以確認閥值的選擇是不適合
        %figure,histogram(matrix)
        [t1,t2]=graythresh(matrix);
        T(1:2,Num)=[t1;t2];
        %若t1過小 設定一個最低值 過濾影像強度很小的地方
        if t1<0.15 
            t1=0.15
            Binary_img_T1(x1:x2,y1:y2) =imbinarize(matrix,t1);   
            Binary_img_T2toT1(x1:x2,y1:y2)=imbinarize(matrix,t1);
        %觀察histogram發現很多根本沒有值超過0.7 因此將t2處理一下
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
%         這邊是用來檢查裁減時是否裁減正確 會將裁減的部分存入matrix_N裡
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