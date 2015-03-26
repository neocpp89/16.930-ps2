function [area] = calculateArea(mesh, master)
%AREACIRCLE Calcualte the area and perimeter of a unit circle
%   [AREA1,AREA2,PERIM]=AREACIRCLE(SP,PORDER)
%
%      SIZ:       Desired element size 
%      PORDER:    Polynomial Order of Approximation (default=1)
%      AREA1:      Area of the circle calculated by volume integrals(\pi)
%      AREA2:      Area of the circle calculate by Div and surface integrals (\pi)
%      PERIM:     Perimeter of the circumference (2*\pi)
%

phimat(:,:) = master.shap(:,1,:);
dphixmat(:,:) = master.shap(:,2,:);
dphiymat(:,:) = master.shap(:,3,:);
area = 0;
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
    area = area + sum(master.gwgh .* detJ);
end
end
