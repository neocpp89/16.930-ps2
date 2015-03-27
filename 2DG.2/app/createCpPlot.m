function [] = createLiftAndDragPlots(mesh, alpha)
    if (nargin < 1)
        mesh = mkmesh_trefftz(15,30,3);
    end
    if (nargin < 2)
        alpha = 10;
    end
    master = mkmaster(mesh);

    [psi, vel_a, gamma_a] = getAirfoilData(alpha, mesh);
    vel = calculateVelFromPsi(mesh, master, psi);
    Cp = calculatePressureCoefficientFromVel(vel);
    h = figure; 
    scaplot(mesh, Cp, [-3,2],1); % force a nice curved plot by using the refinement
    set(h, 'units', 'inches', 'position', [1 1 5 5])
    set(h, 'PaperUnits','centimeters');
    set(h, 'Units','centimeters');
    pos=get(h,'Position');
    set(h, 'PaperSize', [pos(3) pos(4)]);
    set(h, 'PaperPositionMode', 'manual');
    set(h, 'PaperPosition',[0 0 pos(3) pos(4)]);
    title('Cp at 10 degrees');
    print('Cp.pdf', '-dpdf');
end
