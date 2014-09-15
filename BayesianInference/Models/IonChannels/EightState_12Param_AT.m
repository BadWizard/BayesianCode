classdef EightState_12Param_AT < ExactIonModel
    %EigthStateExactIonModel used for desensitisation
          
    methods(Access=public,Static)
        
        function obj = EightState_12Param_AT()
            obj.kA=3; % 3 open states
            obj.h=0.01;
            obj.k = 12; %12 params - 3 constrained, 1 mr
        end
               
        function Q = generateQ(params,conc)
            Q=zeros(8,8);
            
            %param array defined as follows
            
            %1  alpha2
            %2  beta2
            %3  alpha1a
            %4  beta1a
            %5  alpha1b
            %6  beta1b
            %7  k_{-2}a
            %8  k_{-1}b
            %8  k_{-2}b
            %9  k_{+2}b
            %10 k_{+2}b
            %11 alpha_D
            %12 beta_D
            
            % k_{-1}a = k_{-2}a (7)
            % k_{-1}b = k_{-2}b (9)
            % k_{+1}b = k_{+2}b (10)
            
            % k_{+1}a is set by mr (8*9*11*13)/(12*9*7)
            
            Q(1,1) = -(params(1)+params(11));
            Q(1,2) = 0;
            Q(1,3) = 0;
            Q(1,4) = params(1);
            Q(1,5) = 0;
            Q(1,6) = 0;
            Q(1,7) = 0;
            Q(1,8) = params(11);           
            
            
            Q(2,1) = 0;
            Q(2,2) = -params(3);
            Q(2,3) = 0;
            Q(2,4) = 0;
            Q(2,5) = params(3);
            Q(2,6) = 0;
            Q(2,7) = 0;
            Q(2,8) = 0;
            
            Q(3,1) = 0;
            Q(3,2) = 0;
            Q(3,3) = -params(5);
            Q(3,4) = 0;
            Q(3,5) = 0;
            Q(3,6) = params(5);
            Q(3,7) = 0;
            Q(3,8) = 0;

            Q(4,1) = params(2);
            Q(4,2) = 0;
            Q(4,3) = 0;
            Q(4,5) = params(9);
            Q(4,6) = params(8);
            Q(4,7) = 0;
            Q(4,8) = 0;
            Q(4,4) = -sum(Q(4,:));
            
            Q(5,1) = 0;
            Q(5,2) = params(4); 
            Q(5,3) = 0;
            Q(5,4) = params(10) * conc;
            Q(5,6) = 0;
            Q(5,7) = params(8);
            Q(5,8) = 0;
            Q(5,5) = -sum(Q(5,:));
            
            Q(6,1) = 0;
            Q(6,2) = 0;
            Q(6,3) = params(6);
            Q(6,4) = params(7) * conc;
            Q(6,5) = 0;
            Q(6,7) = params(9);
            Q(6,8) = 0;
            Q(6,6) = -sum(Q(6,:));
            
            Q(7,1) = 0;
            Q(7,2) = 0;
            Q(7,3) = 0;
            Q(7,4) = 0;
            Q(7,5) = conc*((params(7))*params(9)*(params(8))*(params(10)))/(params(9)*(params(10))*params(8)); %mr
            Q(7,6) = params(10) * conc;
            Q(7,8) = 0;
            Q(7,7) = -sum(Q(7,:));
            
            %desensitised state
            Q(8,1) = params(12);
            Q(8,2) = 0;
            Q(8,3) = 0;
            Q(8,4) = 0;
            Q(8,5) = 0;
            Q(8,6) = 0;
            Q(8,7) = 0;
            Q(8,8) = -sum(Q(8,:));
            
        end
        
        function sample = samplePrior()
            %in this model we have two uniform priors
            sample = unifrnd(1e-2,1e10,[12 1]);         
        end
        
        function logPrior = calcLogPrior(params)
            logPrior = sum(log(unifpdf(params,1e-2,1e10)));   
        end
        
        function derivLogPrior = calcDerivLogPrior(params)
            if isinf(SevenState_10Param_AT.calcLogPrior(params))
                derivLogPrior = -Inf;
            else
                derivLogPrior = 0;
            end   
        end        
    end
end