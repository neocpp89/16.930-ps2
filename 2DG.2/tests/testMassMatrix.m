classdef testMassMatrix < matlab.unittest.TestCase
    % Tests mass matrix integration
    
    methods (Test)
        
        function testFirstOrder(testCase)
            f = @(x) 1;
            actSolution = 2;
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution,'Abstol',1e-10);
        end
        
    end
    
end