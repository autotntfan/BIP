# Parabolic Hough Transform  
language：Matlab  
general form of a parabolic function： <img src="https://latex.codecogs.com/gif.latex?y=ax^2&plus;bx&plus;c" title="y=ax^2+bx+c" />  
define Hough space：parameter space  i.e. a-b-c space instead of r-θ space
###  Input Parameters

```
X=[x1,x2,x3;y1,y2,y3];            %Selected to check if the three points are on a parabola
UL=[a_upperlimit,b_upperlimit]    %Selected interval: a_upperlimit-20 < a < a_upperlimit  and b_upperlimit-20 < b < b_upperlimit
ParabolicHoughTransform (X,UL)
```

For example
```
ParabolicHoughTransform([2,2,3;4,8,13],[10,10])
```
Check three points (2,4) (2,8) (3,13) in -10 < a < 10 and -10 < b < 10 which can lie on a parabola.
Obviously,(2,4) (2,8) both have x = 2 so that must can't lie on a parabola.

###  Output
Can be NO output argument only checking the transformation.
Display exactly/approximately solutions for a,b,c that can help you to compare with difference,the location of points on the final figure using ParabolicHoughTransform and drawn  with A_T,B_T,C_T using builted-in function '''plot'''.

```
[A_T,B_T,C_T]=ParabolicHoughTransform([2,2,3;4,8,13],[10,10])
```
However the function will figure a series of planes in 3-D.
1. Three points where they are in x-y space.
2. Mapping first point to Hough space.
3. Mapping second point to Hough space.
4. Mapping third point to Hough space.
5. Mapping all points to Hough space.Where is there interaction points if it exists.Otherwise,print "They can't form a parabola"
6. Plot a figure if they are the same points,a straightline,or on a (approximatly/exactly) parabola.

###  For example  
![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e10.jpg)  
<img src="https://latex.codecogs.com/gif.latex?y=x^2&plus;2x&plus;1=(x&plus;1)^2" title="y=x^2+2x+1=(x+1)^2" />and we wanna check whether or not the point:(4,6) lies on the parabola.  
First,we select three points lie on the parabola and be mapped to hough space(parameter space).  
![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e11.png) ![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e12.png) 
![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e13.png)  
Place three planes in the same scale.  
![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e15.png)  
We find that there exists a interaction  point:(1,2,1),which means that a.b.c are 1.2.1 respectively.Hence,the parabolic function is <img src="https://latex.codecogs.com/gif.latex?y=x^2&plus;2x&plus;1=(x&plus;1)^2" title="y=x^2+2x+1=(x+1)^2" /> as we know.  
Now,we map (4,6) to hough space then place four planes in the same scale.  
![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e14.png)  ![image](https://github.com/autotntfan/BIP/blob/master/Midterm/image/e16.png)  
We can find that the yellow plane,which is mapped from point(4,6),doesn't interact other planes at previous point (1,2,1).So we can conclude that points lie on a parabola must interact at a point in the hough space.  



