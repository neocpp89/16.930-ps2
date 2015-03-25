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
% There's probably a way to vectorize this, but I'm not so good with matlab.
phimat(:,:) = master.shap(:,1,:);
dphixmat(:,:) = master.shap(:,2,:);
dphiymat(:,:) = master.shap(:,3,:);
area1 = 0;
for nt=1:size(mesh.dgnodes,3)
    xy(:,:) = mesh.dgnodes(:,:,nt);
    xg = phimat'*xy;
    dxgdx = dphixmat'*xy;
    dxgdy = dphiymat'*xy;
    J(1, 1, :) = dxgdx(:, 1);
    J(1, 2, :) = dxgdx(:, 2);
    J(2, 1, :) = dxgdy(:, 1);
    J(2, 2, :) = dxgdy(:, 2);
    for g=1:size(J, 3)
        detJ(g, 1) = det(J(:,:,g));
    end
    area1 = area1 + sum(master.gwgh .* detJ);
end

% Method two. Use the divergence theorem and calculate line integrals.
area2 = calculateAreaFromDivergence(mesh, master);

% Calculate circumference with line integrals.
perim = calculatePerimeterOfBoundary(mesh, master);

end
