function [psi,vel_analytic,gamma_analytic] = getAirfoilData(alpha, mesh)
    if (nargin < 2)
        mesh = mkmesh_trefftz(15,30,3);
    end
    master = mkmaster(mesh);

    mx = mesh.dgnodes(:,1,:);
    my = mesh.dgnodes(:,2,:);
    mx = reshape(mx, [], 1);
    my = reshape(my, [], 1);
    [psi, vx, vy, gamma_analytic] = potential_trefftz(mx, my, 1, alpha);
    psi = reshape(psi, size(mesh.dgnodes,1), size(mesh.dgnodes,3));
    vx = reshape(vx, size(mesh.dgnodes,1), size(mesh.dgnodes,3));
    vy = reshape(vy, size(mesh.dgnodes,1), size(mesh.dgnodes,3));
    vel_analytic(:,1,:) = vx;
    vel_analytic(:,2,:) = vy;
end
