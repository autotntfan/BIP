clear;
close all;

%計算平均和標準差
T=readtable('HW9_excel.xlsx');
[r c]=size(T);
T_title=T.Properties.VariableNames;
data=table2cell(T);
T = sortrows(T,'Group','ascend');
ind=find(T.Group==1,1,'last');
Group1=T(1:ind,1:c);
Group2=T(ind+1:end,1:c);
G11=[num2str(mean(Group1.Weight_kg_)) '(' num2str(std(Group1.Weight_kg_)) ')'];
G21=[num2str(mean(Group2.Weight_kg_)) '(' num2str(std(Group2.Weight_kg_)) ')'];
G12=[num2str(mean(Group1.CBFRate_Ml__min_2_100g_)) '(' num2str(std(Group1.CBFRate_Ml__min_2_100g_)) ')'];
G22=[num2str(mean(Group2.CBFRate_Ml__min_2_100g_)) '(' num2str(std(Group2.CBFRate_Ml__min_2_100g_)) ')'];
newT=table({['G1_' num2str(numel(Group1.Group))];['G2_' num2str(numel(Group2.Group))]},{G11;G21},{G12;G22});
%我發現上次作業寫錯了，上次使用num2str(numel(Group1))這計算了Group1裡面所有資料量而不是我所要的人數
%應改成以下
newT.Properties.VariableNames={'Q1',['Weights_' num2str(numel(T.Weight_kg_))],['CBF_' num2str(numel(T.CBFRate_Ml__min_2_100g_))]};
newT
%Q1
data=[Group1.Weight_kg_;Group2.Weight_kg_]';
group=[Group1.Group;Group2.Group]';
[p,tbl,stats] = anova1(data,group)
data=[Group1.CBFRate_Ml__min_2_100g_;Group2.CBFRate_Ml__min_2_100g_]';
[p,tbl,stats] = anova1(data,group)
%Q2
GA=[2.5 3.7 1.9 2.4 4.4 1.8 2.2 2.0 0.6 2.9];
GB=[6.3 6.2 9.3 4.3 8.8 6.8 1.0 5.3 5.8 5.0];
GC=[4.8 9.3 5.0 11.7 7.1 8.7 10.7 9.4 9.6 5.4];
hogg=[GA;GB;GC]';
[p,tbl,stats] = anova1(hogg);
%Q3
ts = tinv([0.025  0.975],57);     
CI = 25 + ts*2.7/sqrt(58)                     
%Q4
p = 1 - chi2cdf(16/15,1)
%Q5
B=[15.9;16.0;16.5;17;17.6;18.1;18.4;18.9;18.9;19.6;21.5;21.6;22.9;23.6;24.1;24.5;25.1;25.2;25.6;28;28.7;29.2;30.9];
H=[20.7;22.4;23.1;23.8;24.5;25.3;25.7;30.6;30.6;33.2;33.7;36.6;37.1;37.4;40.8];
p = ranksum(B,H)