



%Example 3. ParabolicHoughTransform(X,UL) P.20
%close all;ParabolicHoughTransform([2,3,5;119,299,899],[51,-1])
%Example 3. ParabolicHoughTransform(X,UL) P.22
%close all;ParabolicHoughTransform([2,-3,3;1,4,17],[10,10])

%example 4. ParabolicHoughTransform(X,UL) P.23
%close all;ParabolicHoughTransform([1,2,3;2,4,6],[10,10])
%final example ParabolicHoughTransform(X,UL) P.24
%close all;ParabolicHoughTransform([2,2,2;2,2,2],[10,10])



%demo
%取兩點同在x=2上 此必定無法形成拋物線 P.25
%close all;ParabolicHoughTransform([2,2,3;4,8,13],[10,10])
%close all;ParabolicHoughTransform([4,4,4;3,27,49],[10,10])
%close all;ParabolicHoughTransform([1,20.56,3.75;2.84,3.4,13/6],[20,15])
%HoughTransform(0.014577259475218658892128279883382,-0.28425655976676384839650145772595,3.0696793002915451895043731778426,[10,10],[3.75,13/6])
figure;
x=-100:100;
y=0.014577259475218658892128279883382*x.^2+-0.28425655976676384839650145772595*x+3.0696793002915451895043731778426;
plot(x,y);
hold on
plot([1,20.56,3.75],[2.84,3.4,13/6],'r*');
title('y=0.014577259475218658892128279883382*x.^2+-0.28425655976676384839650145772595*x+3.0696793002915451895043731778426','FontSize', 24)
xlabel('x','FontSize', 24)
ylabel('y','FontSize', 24)