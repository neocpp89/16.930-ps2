function [area,perim] = areacircle(siz,porder)
%AREACIRCLE Calcualte the area and perimeter of a unit circle
%   [AREA,PERIM]=AREACIRCLE(SP,PORDER)
%
%      SIZ:       Desired element size 
%      PORDER:    Polynomial Order of Approximation (default=1)
%      AREA:      Area of the circle (\pi)
%      PERIM:     Perimeter of the circumference (2*\pi)
%
mesh = mkmesh_circle(siz,porder);
master = mkmaster(mesh);

