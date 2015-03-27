function [vel] = calculateVelFromPsi(mesh, master, psi)
    nsf = shape2d(master.porder, master.plocal, master.plocal(:,2:3));

    for nt=1:size(mesh.t, 1)
        xy(:,:) = mesh.dgnodes(:,:,nt);
        psi_t = psi(:, nt);
        ddx = squeeze(nsf(:,2,:))'*xy; 
        ddy = squeeze(nsf(:,3,:))'*xy; 
        J(1, 1, :) = ddx(:, 1);
        J(1, 2, :) = ddx(:, 2);
        J(2, 1, :) = ddy(:, 1);
        J(2, 2, :) = ddy(:, 2);
        dpsidx = squeeze(nsf(:,2,:))'*psi_t; 
        dpsidy = squeeze(nsf(:,3,:))'*psi_t; 
        for p=1:size(J,3)
            J_p(:,:) = J(:,:,p);
            J_inv = J_p^(-1);
            v = J_inv*[dpsidx(p); dpsidy(p)];
            vel(p, :, nt) = [v(2);-v(1)];
        end
    end
end
