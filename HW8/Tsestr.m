load HW8_fix.mat
img=double(I2warp);
[m,n]=size(img);
O=round([m n]./2); %O(y,x)
newImage=zeros(max([m,n]));

data=zeros(400000,3);
count=1;
%ii:y jj:x
for ii = 1:m
    jj_1=find(img(ii,:)~=0,1,'first');
    jj_2=find(img(ii,:)~=0,1,'last');
    for jj=jj_1:jj_2
        x=jj-O(2);y=O(1)-ii;
        theta=atan(y/x)*180/pi;
        if theta<0
            if x<0
                theta=180+theta;
            else
                theta=360+theta;
            end
        else
            if x<0
                theta=180+theta;
            else
                theta=theta;
            end
        end
        dist=sqrt(x^2+y^2);
        data(count,:)=[img(ii,jj),dist,theta];
        count=count+1;
    end
end

data(:,3)=data(:,3)+10;   
last=find(data(:,1)~=0,1,'last');
for kk =1:last
    if data(kk,3)>360
        data(kk,3)=data(kk,3)-360;
    end
    deg=double(data(kk,3)*pi/180);
    if isnan(deg) 
        continue
    end
    x=O(2)+round(data(kk,2)*cos(deg))+(m-n)/2;
    y=O(1)+round(data(kk,2)*sin(deg));
    newImage(y,x)=data(kk,1);
end
close all
imshow(newImage,[]);

