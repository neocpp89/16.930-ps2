function [normals, ds] = find_normals(mesh)
%FIND_NORMALS Get all the surface normals on the mesh at gauss points.
%   [AREA1,AREA2,PERIM]=AREACIRCLE(SP,PORDER)
%
%      SIZ:       Desired element size 
%      PORDER:    Polynomial Order of Approximation (default=1)
%      AREA1:      Area of the circle calculated by volume integrals(\pi)
%      AREA2:      Area of the circle calculate by Div and surface integrals (\pi)
%      PERIM:     Perimeter of the circumference (2*\pi)
%

master = mkmaster(mesh);
phimat(:,:) = master.shap(:,1,:);
dphixmat(:,:) = master.shap(:,2,:);
dphiymat(:,:) = master.shap(:,3,:);
sh1dmat(:,:) = master.sh1d(:,1,:);
dsh1dmat(:,:) = master.sh1d(:,2,:);

for ip=1:size(master.shap, 3)
    jj(ip,:,:) = [dphixmat(:,ip), dphiymat(:,ip);]';
    jj(ip,:,:)
end

area2 = 0;
normals = zeros(size(mesh.t,1), size(mesh.t2f, 3), size(master.gp1d, 1), 2); % assume 2d
ds = zeros(size(mesh.t,1), size(mesh.t2f, 3), size(master.gp1d, 1), 2); % assume 2d
for nt=1:size(mesh.t, 1)
    faces(:, 1) = mesh.t2f(nt, :);
    cw = (faces < 0);
    f = abs(faces);
    xy(:,:) = mesh.dgnodes(:,:,nt);
    xg = phimat'*xy;
    for ip=1:size(master.shap, 1)
        J(:,:,ip) = squeeze(jj(ip,:,:))*xy;
    end
    J
    xg
    %{
    dxgdx = dphixmat'*xy;
    dxgdy = dphiymat'*xy;
    J(1, 1, :) = dxgdx(:, 1);
    J(1, 2, :) = dxgdx(:, 2);
    J(2, 1, :) = dxgdy(:, 1);
    J(2, 2, :) = dxgdy(:, 2);
    dxgdx
    dxgdy
    %}
    for g=1:size(J, 3)
        J(:,:,g)
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
                    J_inv
                    n(p,:) = (J_inv*[-1;0])';
                    t(p,:) = (J_inv*[0;-1])';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
            case 2
                for p=1:size(J,3)
                    J_inv = J(:,:,p)^(-1);
                    J_inv
                    n(p,:) = (J_inv*[0;-1])';
                    t(p,:) = (J_inv*[1;0])';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
            case 3
                for p=1:size(J,3)
                    J_inv = J(:,:,p)^(-1);
                    J_inv
                    n(p,:) = (J_inv*[1;1]/sqrt(2))';
                    t(p,:) = (J_inv*[-1;1]/sqrt(2))';
                    %n(p,:) = n(p,:)/norm(n(p,:))
                end
        end
        n = n(dgidx,:);
        n = normr(n);
        ng = sh1dmat'*n;
        ng = normr(ng);
        t = t(dgidx,:);
        ds(nt, nf, :, :) = sh1dmat'*t;
        normals(nt, nf, :, :) = ng;
    end
end
end
