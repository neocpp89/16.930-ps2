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

%{
Find the normals
xi = master.ploc1d;
gi = master.gp1d;
e1 = [1-xi, xi];
e2 = [0*xi, 1-xi];
e3 = [xi, 0*xi];
g1 = [1-gi, gi];
g2 = [0*gi, 1-gi];
g3 = [gi, 0*gi];
n1 = [1,1];
n2 = [-1,0];
n3 = [0,-1];
nsf1 = shape2d(porder, e1, g1);
nsf2 = shape2d(porder, e2, g2);
nsf3 = shape2d(porder, e3, g3);
%}

phimat(:,:) = master.shap(:,1,:);
dphixmat(:,:) = master.shap(:,2,:);
dphiymat(:,:) = master.shap(:,3,:);
sh1dmat(:,:) = master.sh1d(:,1,:);
dsh1dmat(:,:) = master.sh1d(:,2,:);
area2 = 0;
for nt=1:size(mesh.t, 1)
    faces(:, 1) = mesh.t2f(nt, :);
    cw = (faces < 0);
    f = abs(faces);
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
    for nf=1:size(faces,1)
        dgidx = master.perm(:, nf, cw(nf)+1);
        line_xy = xy(dgidx,:);
        line_J = J(:,:,dgidx);
        line_xg = sh1dmat'*line_xy;
        switch nf
            case 1
                for p=1:size(J,3)
                    J_inv = J(:,:,p)^(-1);
                    n(p,:) = (J_inv*[-1;0])';
                    t(p,:) = (J_inv*[0;-1])';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
            case 2
                for p=1:size(J,3)
                    J_inv = J(:,:,p)^(-1);
                    n(p,:) = (J_inv*[0;-1])';
                    t(p,:) = (J_inv*[1;0])';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
            case 3
                for p=1:size(J,3)
                    J_inv = J(:,:,p)^(-1);
                    n(p,:) = (J_inv*[1;1])';
                    t(p,:) = (J_inv*[-1;1])';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
        end
        n = n(dgidx,:);
        n = normr(n);
        ng = sh1dmat'*n;
        ng = normr(ng);
        dj = sh1dmat'*detJ(dgidx,1);
        tm = 1./sqrt(sum((sh1dmat'*t(dgidx,:)).^2,2));
        disp(tm)
        line_xg
        ng
        dA = 0.5*master.gw1d'*(sum(line_xg.*ng,2))
        area2 = area2 + dA;
        nn = line_xy + 0.05*n;
        hold on;
        plot(line_xg(:,1), line_xg(:,2));
        for xx=1:size(nn,1)
            plot([line_xy(xx, 1), nn(xx,1)], [line_xy(xx, 2), nn(xx,2)]);
        end
        plot(line_xy(:,1), line_xy(:,2), '.');
    end
end
ylim auto;
xlim auto;
area2

% Caclulate circumference with line integrals.
perim = 0
boundary_faces = mesh.f(mesh.f(:,4) < 0, :)
for n=1:size(boundary_faces, 1)
end

end
