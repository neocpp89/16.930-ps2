classdef testShape1D < matlab.unittest.TestCase
    % Tests 1D shape functions on master element
    % I only test at low-order because I know how to calculate those easily.
    
    methods (Test)
        function testFirstOrder(testCase)
            p = 1;
            nodepts = [-1, 1];
            testpts = [-1, -0.5, 0, 0.5, 1];

            nsf = shape1d(p, nodepts, testpts);

            expected_values = [ 1, 0.75, 0.5, 0.25, 0; ...
                                0, 0.25, 0.5, 0.75, 1 ];
            expected_derivatives = 0.5*[-1, -1, -1, -1, -1; ...
                                        1, 1, 1, 1, 1];
            actual_values(:, :) = nsf(:, 1, :);
            actual_derivatives(:, :) = nsf(:, 2, :);
            testCase.verifyEqual(actual_values, expected_values,'Abstol',1e-10);
            testCase.verifyEqual(actual_derivatives, expected_derivatives,'Abstol',1e-10);
        end

        function testSecondOrder(testCase)
            p = 2;
            nodepts = [-1, 0, 1];
            testpts = [-1, -0.5, 0, 0.5, 1];

            nsf = shape1d(p, nodepts, testpts);

            expected_values = [ 1, 0.375, 0, -0.125, 0; ...
                                0, 0.75, 1, 0.75, 0; ...
                                0, -0.125, 0, 0.375, 1 ];
            expected_derivatives = [ -1.5, -1, -0.5, 0, 0.5; ...
                                2, 1, 0, -1, -2; ...
                                -0.5, 0, 0.5, 1, 1.5];
            actual_values(:, :) = nsf(:, 1, :);
            actual_derivatives(:, :) = nsf(:, 2, :);
            testCase.verifyEqual(actual_values, expected_values,'Abstol',1e-10);
            testCase.verifyEqual(actual_derivatives, expected_derivatives,'Abstol',1e-10);
        end
    end
end
