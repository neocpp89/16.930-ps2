function [S] = calculatePerimeter(mesh, master)
    phimat(:,:) = master.shap(:,1,:);
    dphixmat(:,:) = master.shap(:,2,:);
    dphiymat(:,:) = master.shap(:,3,:);
    sh1dmat(:,:) = master.sh1d(:,1,:);
    dsh1dmat(:,:) = master.sh1d(:,2,:);

    nsf(1,:,:,:) = shape2d(master.porder, master.plocal, [1.-0.5.*(1.+master.gp1d), 0.5.*(1.+master.gp1d)]);
    nsf(2,:,:,:) = shape2d(master.porder, master.plocal, [zeros(size(master.gp1d)), 1.-0.5.*(1.+master.gp1d)]);
    nsf(3,:,:,:) = shape2d(master.porder, master.plocal, [0.5.*(1.+master.gp1d), zeros(size(master.gp1d))]);

    S = 0;
    for nt=1:size(mesh.t, 1)
        faces(:, 1) = mesh.t2f(nt, :);
        cw = (faces < 0);
        f = abs(faces);
        xy(:,:) = mesh.dgnodes(:,:,nt);
        for nf=1:size(faces,1)
            ff = abs(faces(nf));
            if (mesh.f(ff, 4) > 0)
                continue
            end
            dgidx = master.perm(:, nf, cw(nf)+1);
            line_xg = squeeze(nsf(nf,:,1,:))'*xy;
            line_dxgdx = squeeze(nsf(nf,:,2,:))'*xy; 
            line_dxgdy = squeeze(nsf(nf,:,3,:))'*xy; 
            line_J(1, 1, :) = line_dxgdx(:, 1);
            line_J(1, 2, :) = line_dxgdx(:, 2);
            line_J(2, 1, :) = line_dxgdy(:, 1);
            line_J(2, 2, :) = line_dxgdy(:, 2);
            switch nf
                case 2
                    for p=1:size(line_J,3)
                        line_J_p = line_J(:,:,p);
                        line_J_inv = line_J_p^(-1);
                        n(p,:) = (line_J_inv*[-1;0])';
                        ds(p, 1) = sqrt(sum((line_J_p'*[0;-1]).^2));
                    end
                case 3
                    for p=1:size(line_J,3)
                        line_J_p = line_J(:,:,p);
                        line_J_inv = line_J_p^(-1);
                        n(p,:) = (line_J_inv*[0;-1])';
                        ds(p, 1) = sqrt(sum((line_J_p'*[1;0]).^2));
                    end
                case 1
                    for p=1:size(line_J,3)
                        line_J_p = line_J(:,:,p);
                        line_J_inv = line_J_p^(-1);
                        n(p,:) = (line_J_inv*[1;1])';
                        ds(p, 1) = sqrt(sum((line_J_p'*[-1;1]).^2));
                    end
            end
            ng = normr(n);
            dsg = ds;
            dS = master.gw1d'*dsg;
            S = S + dS;
        end
    end
end
