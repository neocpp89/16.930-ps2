classdef testShape2D < matlab.unittest.TestCase
    % Tests 1D shape functions on master element
    % I only test first-order because I know how to calculate those easily.
    
    methods (Test)
        function testFirstOrder(testCase)
            p = 1;
            nodepts = [0,0; 0,1; 1,0;];
            testpts = [0,0; 0,0.5; 0,1; 0.5,0.5; 1,0; 0.5,0;];

            nsf = shape2d(p, nodepts, testpts);

            expected_values = [ 1, 0.5, 0, 0, 0, 0.5; ...
                                0, 0.5, 1, 0.5, 0, 0; ...
                                0, 0, 0, 0.5, 1, 0.5];
            expected_derivatives_x = [-1, -1, -1, -1, -1, -1; ...
                                    0, 0, 0, 0, 0, 0; ...
                                    1, 1, 1, 1, 1, 1;];
            expected_derivatives_y = [-1, -1, -1, -1, -1, -1; ...
                                     1, 1, 1, 1, 1, 1; ...
                                    0, 0, 0, 0, 0, 0];
            actual_values(:, :) = nsf(:, 1, :);
            actual_derivatives_x(:, :) = nsf(:, 2, :);
            actual_derivatives_y(:, :) = nsf(:, 3, :);
            testCase.verifyEqual(actual_values, expected_values,'Abstol',1e-10);
            testCase.verifyEqual(actual_derivatives_x, expected_derivatives_x,'Abstol',1e-10);
            testCase.verifyEqual(actual_derivatives_y, expected_derivatives_y,'Abstol',1e-10);
        end
    end
end
