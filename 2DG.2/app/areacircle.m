function [area1,area2,perim] = areacircle(siz,porder)
%AREACIRCLE Calcualte the area and perimeter of a unit circle
%   [AREA1,AREA2,PERIM]=AREACIRCLE(SP,PORDER)
%
%      SIZ:       Desired element size 
%      PORDER:    Polynomial Order of Approximation (default=1)
%      AREA1:      Area of the circle calculated by volume integrals(\pi)
%      AREA2:      Area of the circle calculate by Div and surface integrals (\pi)
%      PERIM:     Perimeter of the circumference (2*\pi)
%
if (nargin < 2)
    porder = 1;
end
mesh = mkmesh_circle(siz,porder);
master = mkmaster(mesh);

% Method one. Just calculate volume integrals like you would think.
area1 = calculateArea(mesh, master);

% Method two. Use the divergence theorem and calculate line integrals.
area2 = calculateAreaFromDivergence(mesh, master);

% Calculate circumference with line integrals.
perim = calculatePerimeter(mesh, master);

end
