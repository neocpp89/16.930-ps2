function [S] = calculatePerimeterOfBoundary(mesh, master)
    phimat(:,:) = master.shap(:,1,:);
    dphixmat(:,:) = master.shap(:,2,:);
    dphiymat(:,:) = master.shap(:,3,:);
    sh1dmat(:,:) = master.sh1d(:,1,:);
    dsh1dmat(:,:) = master.sh1d(:,2,:);
    S = 0;
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
            ff = abs(faces(nf));
            if (mesh.f(ff, 4) > 0)
                continue
            end
            dgidx = master.perm(:, nf, cw(nf)+1);
            line_xy = xy(dgidx,:);
            line_xg = sh1dmat'*line_xy;
            switch nf
                case 2
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[-1;0])';
                        ds(p, 1) = sqrt(sum((J_p'*[0;-1]).^2));
                    end
                case 3
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[0;-1])';
                        ds(p, 1) = sqrt(sum((J_p'*[1;0]).^2));
                    end
                case 1
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[1;1])';
                        ds(p, 1) = sqrt(sum((J_p'*[-1;1]).^2));
                    end
            end
            n = n(dgidx,:);
            n = normr(n);
            ng = sh1dmat'*n;
            ng = normr(ng);
            dsg = sh1dmat'*ds(dgidx,1);
            dS = master.gw1d'*dsg;
            S = S + dS;
        end
    end
end
