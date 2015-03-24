classdef testDivergenceArea < matlab.unittest.TestCase
    % Tests method for integrating area based on surface intgrals.
    % I only test first-order because I know how to calculate those easily.
    
    methods (Test)
        function testMasterIntegrate(testCase)
            p = 1;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);

            actual_area = calculateAreaFromDivergence(mesh, master);
            expected_area = 0.5;
            testCase.verifyEqual(actual_area, expected_area,'Abstol',1e-10);
        end

        function testMasterIntegrateScaledAndTranslated(testCase)
            p = 2;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);
            mesh.dgnodes = mesh.dgnodes*2.124 + 022.41;

            actual_area = calculateAreaFromDivergence(mesh, master);
            expected_area = 0.5*2.124*2.124;
            testCase.verifyEqual(actual_area, expected_area,'Abstol',1e-10);
        end

        function testArbitrary1(testCase)
            p = 1;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);
            mesh.dgnodes = [0.2649, 0.4600; -0.2649, 0.4600; -0.0000, -0.0021];
            actual_area = calculateAreaFromDivergence(mesh, master);

            corners = mesh.dgnodes;
            dista = sqrt(sum((corners(1,:)-corners(2,:)).^2))
            distb = sqrt(sum((corners(2,:)-corners(3,:)).^2))
            distc = sqrt(sum((corners(1,:)-corners(3,:)).^2))
            s = (dista+distb+distc)/2.0
            expected_area = sqrt(s*(s-dista)*(s-distb)*(s-distc))
            testCase.verifyEqual(actual_area, expected_area,'Abstol',1e-10);
        end
    end
end
