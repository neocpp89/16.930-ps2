function [] = createLiftAndDragPlots(alpharange)
    if (nargin < 1)
        alpharange = [-3:0.5:10];
    end
    mesh = mkmesh_trefftz(15,30,3);
    [cl,cd,cl_a,a]=calculateLiftAndDragCoefficients(alpharange,mesh);
    h = figure; 
    plot(a,cd, 'xr', a,cl, 'ob', a,cl_a, '-k', 'MarkerSize', 10);
    set(h, 'units', 'inches', 'position', [1 1 5 5])
    set(h, 'PaperUnits','centimeters');
    set(h, 'Units','centimeters');
    pos=get(h,'Position');
    set(h, 'PaperSize', [pos(3) pos(4)]);
    set(h, 'PaperPositionMode', 'manual');
    set(h, 'PaperPosition',[0 0 pos(3) pos(4)]);
    xlabel('Airfoil Angle (degrees)');
    ylabel('Lift or Drag Coefficient');
    title('Lift and Drag vs Angle');
    legend('Drag Coefficient','Lift Coefficient','Analytical Lift Coefficient', 'Location', 'northwest');
    print('DragAndLift.pdf', '-dpdf');
end
