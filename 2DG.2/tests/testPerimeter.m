classdef testPerimeter < matlab.unittest.TestCase
    % Tests method for integrating area based on surface intgrals.
    % I only test first-order because I know how to calculate those easily.
    
    methods (Test)
        function testMasterPerimeter(testCase)
            p = 1;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);

            actual_perimeter = calculatePerimeter(mesh, master);
            expected_perimeter = 2 + sqrt(2);
            testCase.verifyEqual(actual_perimeter, expected_perimeter,'Abstol',1e-10);
        end

        function testMasterPerimeterScaledAndTranslated(testCase)
            p = 2;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);
            mesh.dgnodes = mesh.dgnodes*2.124 + 022.41;

            actual_perimeter = calculatePerimeter(mesh, master);
            expected_perimeter = 2.124*(2+sqrt(2));
            testCase.verifyEqual(actual_perimeter, expected_perimeter,'Abstol',1e-10);
        end

        function testArbitrary1(testCase)
            p = 1;
            mesh = mkmesh_master(p);
            master = mkmaster(mesh);
            mesh.dgnodes = [0.2649, 0.4600; -0.2649, 0.4600; -0.0000, -0.0021];
            actual_perimeter = calculatePerimeter(mesh, master);

            corners = mesh.dgnodes;
            dista = sqrt(sum((corners(1,:)-corners(2,:)).^2));
            distb = sqrt(sum((corners(2,:)-corners(3,:)).^2));
            distc = sqrt(sum((corners(1,:)-corners(3,:)).^2));
            expected_perimeter = dista+distb+distc;
            testCase.verifyEqual(actual_perimeter, expected_perimeter,'Abstol',1e-10);
        end
    end
end
