clear;
close all;
%%%------------------------------------Q1-----------------------------------
%讀取檔案雖然會跳警告，但只是差別在tilte要不要放在1st row而已
%放在1st row會讓資料起點不是1st row因此還是決定讓他跳個警告
%若不想跳警告可以使用
%T=readtable('HW9_excel.xlsx','ReadVariableNames',false);
T=readtable('HW9_excel.xlsx');
[r c]=size(T);
T_title=T.Properties.VariableNames;
data=table2cell(T);
T = sortrows(T,'Group','ascend');
ind=find(T.Group==1,1,'last');
Group1=T(1:ind,1:c);
Group2=T(ind+1:end,1:c);
%找G1男女生數量
MofG1=numel(find(string(Group1.Sex)=='M'));
FofG1=numel(find(string(Group1.Sex)=='F'));
%找G2男女生數量
MofG2=numel(find(string(Group2.Sex)=='M'));
FofG2=numel(find(string(Group2.Sex)=='F'));
%表示成 男/女 人數
G1_Gender=[num2str(MofG1) '/' num2str(FofG1)];
G2_Gender=[num2str(MofG2) '/' num2str(FofG2)];
%計算G1各項變數Mean/std
T_ind=[4 6 7 10 11];
newT_variable={'Age','Height','Weight','Vel_rate','Flow_rate'};

for ii=1:numel(T_ind)
    ind=T_ind(ii);
    m=mean(Group1.(string(T_title{ind})));
    s=std(Group1.(string(T_title{ind})));
    ms=[num2str(m) '(' num2str(s) ')'];
    eval(['G1_' newT_variable{ii} '=ms;']);
    m=mean(Group2.(string(T_title{ind})));
    s=std(Group2.(string(T_title{ind})));
    ms=[num2str(m) '(' num2str(s) ')'];
    eval(['G2_' newT_variable{ii} '=ms;']);
end
%匯出表格
newT=table({'Gender(M/F)';'Age(years)';'Height(m)';'Weight(kg)';'Vel rate(cm/s^2)';'Flow rate(ml/(min^2*100g)'},...
{G1_Gender;G1_Age;G1_Height;G1_Weight;G1_Vel_rate;G1_Flow_rate},{G2_Gender;G2_Age;G2_Height;G2_Weight;G2_Vel_rate;G2_Flow_rate});
%投影片要求Group1 (n=?)但table抬頭無法命名含有()、=、空格的名字，因此用Group1_n代替
newT.Properties.VariableNames={'Variable',['Group1_' num2str(numel(Group1))],['Group2_' num2str(numel(Group2))]};
newT
%%%------------------------------------Q2-----------------------------------
%過濾出疾病分類有哪些
[G Disease]=findgroups(T.DiseaseHistory);
ratio=[];
for ii = 1:max(G(:))
    %計算各種疾病有幾個人
    num=numel(find(G==ii));
    eval(['Disease_' num2str(ii) '=num;'])
    ratio=[ratio,num];
end
%畫出來 疾病種類用PPT補上
pie(ratio);
% 查看顏色代表哪個疾病
% pie(ratio,{Disease{1},Disease{2},Disease{3},Disease{4}})
%%%------------------------------------Q3-----------------------------------
figure,h=histogram(T.Weight_kg_ );
% 為了讓數字顯示在正中間比較好看 因此x+5
x = h.BinEdges +5 ;
y = h.Values ;
text(x(1:end-1),y,num2str(y'),'vert','bottom','horiz','center'); 
%%%------------------------------------Q4-----------------------------------
G1_CBF=Group1.CBFRate_Ml__min_2_100g_;
G2_CBF=Group2.CBFRate_Ml__min_2_100g_;
%資料長度不同 補成相同維度
group=[repmat('Group1',size(G1_CBF,1),1);repmat('Group2',size(G2_CBF,1),1)];
figure
B=boxplot([G1_CBF;G2_CBF],group);
hold on;
%reference:https://www.mathworks.com/matlabcentral/answers/398012-adding-a-scatter-of-points-to-a-boxplot
%將值隨機撒在1(G1)附近小範圍內
scatter(ones(size(G1_CBF)).*(1+(rand(size(G1_CBF))-0.5)/10),G1_CBF,'r','filled')
%將值隨機撒在2(G2)附近小範圍內
scatter(1+ones(size(G2_CBF)).*(1+(rand(size(G2_CBF))-0.5)/10),G2_CBF,'r','filled')
% reference:https://www.twblogs.net/a/5d08cfbbbd9eee1e5c8129e3
% 1.Upper Whisker 2.lower Whisker 3.Upper Adjacent value 4.Lower Adjacent value 5.Box 6.Median 7.Outliers
% 因為用get會得到存有兩個相同值的1*2向量，只要取一個就好，因此用mean取出
G1_median=mean(get(B(6,1),'YData'));G2_median=mean(get(B(6,2),'YData'));
G1_IQR=[max(get(B(2,1),'YData')) min(get(B(1,1),'YData'))];
G2_IQR=[max(get(B(2,2),'YData')) min(get(B(1,2),'YData'))];
G1_max=mean(get(B(3,1),'YData'));G2_max=mean(get(B(3,2),'YData'));
G1_min=mean(get(B(4,1),'YData'));G2_min=mean(get(B(4,2),'YData'));
G1_Outliers=get(B(7,1),'YData');G2_Outliers=get(B(7,2),'YData');
G1={num2str(G1_median);num2str(G1_IQR);num2str([G1_min G1_max]);num2str(G1_max);num2str(G1_min);num2str(G1_Outliers)};
G2={num2str(G2_median);num2str(G2_IQR);num2str([G2_min G2_max]);num2str(G2_max);num2str(G2_min);num2str(G2_Outliers)};
%匯出資訊
table({'meidan';'IOR';'95% center range';'maximum';'minimum';'outliers'},G1,G2,'VariableNames',{'subject' 'Group1' 'Group2'})
%%%------------------------------------Q5-----------------------------------
G1_VR=Group1.VelRate_Cm__s_2_;
G2_VR=Group2.VelRate_Cm__s_2_;
%由於error bar定義非常多種 這裡取中點位置為平均值 上下限各為1個標準差
G1_VR_mean=mean(G1_VR);G2_VR_mean=mean(G2_VR);
G1_CBF_mean=mean(G1_CBF);G2_CBF_mean=mean(G2_CBF);
G1_VR_std=std(G1_VR);G2_VR_std=std(G2_VR);
G1_CBF_std=std(G1_CBF);G2_CBF_std=std(G2_CBF);
figure
%投影片要求左方為CBF
yyaxis left
barmatrix1=[G1_CBF_mean G2_CBF_mean;0 0];
B=bar(barmatrix1);
%投影片要求G1 green G2 red
B(1).FaceColor='g';
B(2).FaceColor='r';
%畫出單位
ylabel('ml/(min^2*100g');
hold on;
%由於長條圖不是畫在正中間1的位置或是0.75 1.25而是在奇怪的位置，因此參考以下
%https://www.mathworks.com/matlabcentral/answers/438514-adding-error-bars-to-a-grouped-bar-plot
%所寫的直接拿過來用 
y=[G1_CBF_mean G2_CBF_mean];
err=[G1_CBF_std G2_CBF_std];
ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), err(:,i), '.');
end

yyaxis right
barmatrix1=[0 0;G1_VR_mean G2_VR_mean];
B=bar(barmatrix1);
B(1).FaceColor='g';
B(2).FaceColor='r';
ylabel('cm/s^2');
hold on;
y=[G1_VR_mean G2_VR_mean];
err=[G1_VR_std G2_VR_std];
ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    %由於已知間隔為1 因此第二組圖的水平位置需要+1
    errorbar(1+x, y(:,i), err(:,i), '.','Color','k');
end
set(gca,'xticklabel',["CBF rate","Velocity rate"]);
legend('Group1','Group2','Location','northwest')
