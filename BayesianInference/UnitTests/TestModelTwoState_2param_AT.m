classdef TestModelTwoState_2param_AT < matlab.unittest.TestCase
    properties
        model
        params
        data
    end
    
    methods (TestClassSetup)
        function createExperiment(testCase)
            testCase.model = TwoState_2param_AT();
            testCase.params=[5000; 100];
            testCase.data.tres = 0.000025;
            testCase.data.concs = 1;
            testCase.data.tcrit = 0.004;
            [testCase.data.bursts,~] = load_data(strcat(getenv('P_HOME'), {'/Samples/Simulations/two_state_20000.scn'}),testCase.data.tres,testCase.data.tcrit);
            testCase.data.useChs=1;
        end
    end
    
    methods(Test)
        function testProperties(testCase)
            
            %check defaults
            testCase.verifyEqual(testCase.model.kA,1);
            testCase.verifyEqual(testCase.model.h,0.01);
            testCase.verifyEqual(testCase.model.k,2);
            
            %check non-accessibilty
            try
                testCase.model.kA=2;
            catch ME
                testCase.verifyEqual(ME.identifier,'MATLAB:class:SetProhibited');                
            end

            try
                testCase.model.k=3;
            catch ME
                testCase.verifyEqual(ME.identifier,'MATLAB:class:SetProhibited');                
            end
            
            %check accessibilty
            testCase.model.h=0.1;
            testCase.verifyEqual(testCase.model.h,0.1);
        end
        
        %test Q generation
        function testQ(testCase)
            Q=testCase.model.generateQ(testCase.params,1);
            
            testCase.verifyEqual(Q(1,1),-5000);
            testCase.verifyEqual(Q(1,2),5000);
            testCase.verifyEqual(Q(2,1),100);
            testCase.verifyEqual(Q(2,2),-100);            
        end
        
        function testLikelihood(testCase)
            testCase.verifyEqual(testCase.model.calcLogLikelihood([5000 100],testCase.data),5.472028389472085e+04,'AbsTol', 1e-6);
            testCase.verifyEqual(testCase.model.calcLogLikelihood([15000 1000],testCase.data),4.237073521880039e+04,'AbsTol', 1e-6)
            testCase.verifyEqual(testCase.model.calcLogLikelihood([15000 15],testCase.data),5.919096295697906e+04,'AbsTol', 1e-6)
            testCase.verifyEqual(testCase.model.calcLogLikelihood([20000, 30],testCase.data),5.883299391340421e+04,'AbsTol', 1e-6)
        end
        
        function testCalcLogPosterior(testCase)
            testCase.verifyEqual(testCase.model.calcLogPosterior(testCase.params,testCase.data),5.4674232192860974e+04,'AbsTol', 1e-6)
        end
        
        function testCalcGradLogLikelihood(testCase)
            testCase.verifyEqual(testCase.model.calcGradLogLikelihood(testCase.params,testCase.data),[0.9648010844102828;-20.9003397638298338],'AbsTol', 1e-6)
        end
        
        function testCalcGradLogPosterior(testCase)
            testCase.verifyEqual(testCase.model.calcGradLogPosterior(testCase.params,testCase.data),[0.9648010844102828;-20.9003397638298338],'AbsTol', 1e-6)
        end
        
        function testCalcMetricTensor(testCase)
            testCase.verifyEqual(testCase.model.calcMetricTensor([5000 100],testCase.data),[ 0.0002708839019760 -0.0005984293238726; -0.0005984293238726 0.0269308657152578],'AbsTol', 1e-10)
        end
        
        function testCalcDerivMetricTensor(testCase)
            testCase.verifyEqual(testCase.model.calcDerivMetricTensor([5000 100],testCase.data),zeros(2,2))
        end
        
        function testCalcDerivLogPrior(testCase)
            testCase.verifyEqual(testCase.model.calcDerivLogPrior([5000 100]),0)
            testCase.verifyEqual(testCase.model.calcDerivLogPrior([-1 -1]),-Inf)
        end
        
        function testCalcLogPrior(testCase)
            testCase.verifyEqual(testCase.model.calcLogPrior([5000 100]),-4.6051701859878911e+01,'AbsTol', 1e-6)
            testCase.verifyEqual(testCase.model.calcLogPrior([-1 -1]),-Inf)
        end
        
        function testSamplePrior(testCase)
            rng(1)
            testCase.verifyEqual(testCase.model.samplePrior,[4.1702200470315700e+09;7.2032449344243774e+09],'AbsTol', 1e-6)
            rng('shuffle', 'twister')
        end
    end
    
    methods (TestMethodTeardown)
        function destroyExperiment(testCase)
            clear testCase.experiment
        end
    end    
    
end
