function [cl,cd,cl_analytic,alphas] = calculateLiftAndDragCoefficients(alphas, mesh)
    if nargin < 2
        mesh = mkmesh_trefftz(15,30,3);
    end
    master = mkmaster(mesh);

    for i=1:numel(alphas)
        alpha = alphas(i);
        [psi, vel_a, gamma_a] = getAirfoilData(alpha, mesh);
        vel = calculateVelFromPsi(mesh, master, psi);
        cf = calculateForceCoefficientFromVel(mesh, master, vel);
        alpha_rad = alpha*pi/180.0;
        vinf_dir = [cos(alpha_rad), sin(alpha_rad)];
        vperp_dir = [-sin(alpha_rad), cos(alpha_rad)];
        cd(i) = norm(cf.*vinf_dir);
        cl(i) = norm(cf.*vperp_dir);
        cl_analytic(i) = -0.5*gamma_a;
    end
end
