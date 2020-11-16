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


