function [area] = calculateAreaFromDivergence(mesh, master)
    phimat(:,:) = master.shap(:,1,:);
    dphixmat(:,:) = master.shap(:,2,:);
    dphiymat(:,:) = master.shap(:,3,:);
    sh1dmat(:,:) = master.sh1d(:,1,:);
    dsh1dmat(:,:) = master.sh1d(:,2,:);
    area = 0;
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
            line_xy = xy(dgidx,:)
            line_J = J(:,:,dgidx);
            line_xg = sh1dmat'*line_xy;
            switch nf
                case 2
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[-1;0])';
                        % t(p,:) = (J_inv*[0;-1])';
                        %n(p,:) = n(p,:)/norm(n(p,:))
                        ds(p, 1) = sqrt(sum((J_p'*[0;-1]).^2));
                    end
                case 3
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[0;-1])';
                        % t(p,:) = (J_inv*[1;0])';
                        %n(p,:) = n(p,:)/norm(n(p,:))
                        ds(p, 1) = sqrt(sum((J_p'*[1;0]).^2));
                    end
                case 1
                    for p=1:size(J,3)
                        J_p = J(:,:,p);
                        J_inv = J_p^(-1);
                        n(p,:) = (J_inv*[1;1])';
                        % t(p,:) = (J_inv*[-1;1])';
                        %n(p,:) = n(p,:)/norm(n(p,:))
                        ds(p, 1) = sqrt(sum((J_p'*[-1;1]).^2));
                    end
            end
            n = n(dgidx,:);
            n = normr(n);
            ng = sh1dmat'*n;
            ng = normr(ng);
            dj = sh1dmat'*detJ(dgidx,1);
            dsg = sh1dmat'*ds(dgidx,1);
            % tg = sh1dmat'*t(dgidx, :);
            % tm = 1./sqrt(sum((1./tg).^2,2))
            % tm = sqrt(sum(tg.^2,2));
            line_xg
            ng
            dA = 0.5*master.gw1d'*(sum(line_xg.*ng,2).*dsg)
            area = area + dA;
            nn = line_xy + 0.05*n;
            hold on;
            plot(line_xg(:,1), line_xg(:,2));
            for xx=1:size(nn,1)
                plot([line_xy(xx, 1), nn(xx,1)], [line_xy(xx, 2), nn(xx,2)]);
            end
            plot(line_xg(:,1), line_xg(:,2), '.');
        end
    end
    ylim auto;
    xlim auto;
    axis square;
    area 
end
