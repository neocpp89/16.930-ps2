function [cl,cd,cl_analytic,alphas] = calculateLiftAndDragCoefficients(alphas, mesh)
    if nargin < 2
        mesh = mkmesh_trefftz(15,30,3);
    end
    master = mkmaster(mesh);

    for i=1:numel(alphas)
        [psi, vel_a, gamma_a] = getAirfoilData(alphas(i), mesh);
        vel = calculateVelFromPsi(mesh, master, psi);
        cf = calculateForceCoefficientFromVel(mesh, master, vel);
        vinf_dir = [cos(alphas(i)), sin(alphas(i))];
        vperp_dir = [-sin(alphas(i)), cos(alphas(i))];
        cd(i) = norm(cf.*vinf_dir);
        cl(i) = norm(cf.*vperp_dir);
        cl_analytic(:) = -0.5*gamma_a;
    end
end
