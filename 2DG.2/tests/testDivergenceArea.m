classdef testDivergenceArea < matlab.unittest.TestCase
    % Tests method for integrating area based on surface intgrals.
    % I only test first-order because I know how to calculate those easily.
    
    methods (Test)
        function testMasterIntegrate(testCase)
            p = 2;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);
            mesh.dgnodes = mesh.dgnodes*2.124 + 022.41;

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
                    tm = 1; 
                    switch nf
                        case 2
                            for p=1:size(J,3)
                                J_inv = J(:,:,p)^(-1);
                                n(p,:) = (J_inv*[-1;0])';
                                t(p,:) = (J_inv*[0;-1])';
                                %n(p,:) = n(p,:)/norm(n(p,:))
                            end
                        case 3
                            for p=1:size(J,3)
                                J_inv = J(:,:,p)^(-1);
                                n(p,:) = (J_inv*[0;-1])';
                                t(p,:) = (J_inv*[1;0])';
                                %n(p,:) = n(p,:)/norm(n(p,:))
                            end
                        case 1
                            for p=1:size(J,3)
                                J_inv = J(:,:,p)^(-1);
                                n(p,:) = (J_inv*[1;1]/sqrt(2))';
                                t(p,:) = (J_inv*[-1;1]/sqrt(2))';
                                %n(p,:) = n(p,:)/norm(n(p,:))
                                tm = sqrt(2); 
                            end
                    end
                    n = n(dgidx,:);
                    n = normr(n);
                    ng = sh1dmat'*n;
                    ng = normr(ng);
                    dj = sh1dmat'*detJ(dgidx,1);
                    disp(tm)
                    line_xg
                    ng
                    dA = 0.5*master.gw1d'*(sum(line_xg.*ng,2).*tm)
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
            axis square;

            actual_area = area2;
            expected_area = 1.062;
            testCase.verifyEqual(actual_area, expected_area,'Abstol',1e-10);
        end
    end
end
