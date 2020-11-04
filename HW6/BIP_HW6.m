clear;
close all;
%part1
img=imread('gantrycrane.png');
grayimg=rgb2gray(img);
canny_img=edge(grayimg,'Canny');
figure,imshow(canny_img,[]);
[E, M, A, Gx, Gy, T]=canny(img,0.5,100,10);
figure,imshow(E,[]);
title('E --edge map after non-maximum suppression')
figure,imshow(M,[]);
title('M --smoothed gradient magnitude');
figure,imshow(A,[]);
title('A --gradient angle');
figure,imshow(abs(Gx),[]);
title('Gx --gradient components along x')
figure,imshow(abs(Gy),[]);
title('Gy --gradient components along y');
figure,imshow(T,[]);
title('Bonus T --double thresholding on the resulting image');

%part2
%reference1:https://www.mathworks.com/help/images/ref/houghlines.html
%reference2:https://www.mathworks.com/help/images/ref/hough.html
%�]�����߱�l�O�����u�A�Ҽ{�W�l�i�ण�O���������A�ݭn��theta�ܱ���0���a��
[H,T,R]=hough(E,'THETA',0:0.5:2);
figure
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
title('\rho\theta-plane');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

%threshold�]��0.8*MAX�O�g�L�h�����եX�Ӫ��̨θ�
P=houghpeaks(H,5,'threshold',ceil(0.8*max(H(:))));
%���̤j����
x = T(P(:,2)); 
%���̤j����
y = R(P(:,1));
plot(x,y,'s','color','white');

%�ھ�help houghlines��ƽվ�'FillGap' 'MinLength'���������{��s��P�����
lines = houghlines(E,T,R,P,'FillGap',40,'MinLength',30);
figure, imshow(grayimg), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

%reference1:https://www.mathworks.com/matlabcentral/fileexchange/46859-canny-edge-detection
%reference2:https://idiot3838.pixnet.net/blog/post/194161931
function [E, M, A, Gx, Gy, T]=canny(img,sig,TH,TL)
    %���Nrgb�Ϥ��নgrayscale
    grayimg=rgb2gray(img);
    %step1:smooth the input image with a Gaussian filter
    %sig�O�D�حn�D����J�Ѽ�
    H_1=fspecial('gaussian',[3,3],sig);
    G_img=imfilter(grayimg,H_1);
    %step2:compute the gradient components along x and y with sobel filters
    %�쥻�����[1 0 -1;1 0 -1;1 0 -1]�H��[-1 -1 -1;0 0 0;1 1 1]
    %���j������Ƴ������W�ϥ�sobel
    sobel_x=[1 0 -1;2 0 -2;1 0 -1];
    sobel_y=[-1 -2 -1;0 0 0;1 2 1];
    Gx=filter2(sobel_x,G_img,'same');
    Gy=filter2(sobel_y,G_img,'same');
    %calculate the gradient magnitude after using smoothing(Gaussian) filter
    M=sqrt(Gx.^2+Gy.^2);
    %calculate the gradient angle
    A=180*atan(Gy./Gx)./pi;
    [m,n]=size(A);
    %create matrix E which refers to the edge map after non-maximum suppression
    E=zeros(m,n);
    for jj=1:m
        for kk=1:n
            %���P�_���׬O�_���t�ȡA�N�䭭���0��~180��
            if A(jj,kk)<0
            A(jj,kk)=A(jj,kk)+180;
            end
            %�����k��
            if A(jj,kk)>=22.5 && A(jj,kk) <67.5
                A(jj,kk)=45;
            elseif A(jj,kk)>=67.5 && A(jj,kk) <112.5
                A(jj,kk)=90;             
            elseif A(jj,kk)>=112.5 && A(jj,kk) <157.5  
                A(jj,kk)=135;
            else
                A(jj,kk)=0;
            end
            
        end
    end
    for jj=2:m-1
        for kk=2:n-1
            if  A(jj,kk)==0
                %�p�G�k���᪺����=0 ���߭ȻP������V�̤j�Ȭۤ�
                E(jj,kk) = M(jj,kk) == max([M(jj,kk), M(jj,kk+1), M(jj,kk-1)]);
            elseif A(jj,kk)==45
                %�p�G�k���᪺����=45 ���߭ȻP�k�U ���W��V�̤j�Ȭۤ�
                E(jj,kk) = M(jj,kk) == max([M(jj,kk), M(jj+1,kk-1), M(jj-1,kk+1)]); 
            elseif A(jj,kk)==135
                %�p�G�k���᪺����=135 ���߭ȻP�k�W ���U��V�̤j�Ȭۤ�
                E(jj,kk) = M(jj,kk) == max([M(jj,kk), M(jj+1,kk+1), M(jj-1,kk-1)]); 
            else
                %�p�G�k���᪺����=90 ���߭ȻP������V�̤j�Ȭۤ�
                E(jj,kk) = M(jj,kk) == max([M(jj,kk), M(jj+1,kk), M(jj-1,kk)]);
            end
        end
    end
    %�N�쥻�p�⧹����ױj�׸g�D���j�ȧ��
    E=E.*M;
    %�M�����֭�
    T=zeros(m,n);
    for jj=2:m-1
        for kk=2:n-1
            %�Y���I<TL,���I������t�A�̫ᦨ�~�Ϭ��G�ȤƹϡA�]���]��0
            if E(jj,kk)<TL
                T(jj,kk)=0;
            %�Y���I>TH,���I����t�A�̫ᦨ�~�Ϭ��G�ȤƹϡA�]���]��1
            elseif E(jj,kk)>TH
                T(jj,kk)=1;
            %�Y�����B���֭ȶ��A�P�_�P��K���I�O�_���I���LTH�A�Y���h����ɡAi.e. ���I�]��=1
            elseif E(jj,kk+1)>TH || E(jj-1,kk+1)>TH || E(jj-1,kk)>TH || E(jj-1,kk-1)>TH || E(jj,kk-1)>TH || E(jj+1,kk-1)>TH || E(jj+1,kk)>TH || E(jj+1,kk+1)>TH 
                T(jj,kk)=1;
            end
        end
    end
    
end
    
            

    
    
    
    
    
    
    
    