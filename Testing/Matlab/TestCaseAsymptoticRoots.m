function TestCaseAsymptoticRoots(paramsFile,verbose)

    
    test_params = Test_Setup(paramsFile);
    load(test_params.asymptoticInFile);
    total_tests=11;


    
test_names={'[TEST 1] - test H_AA(s)','[TEST 2] - test H_FF(s)','[TEST 3] - test W_AA(s)','[TEST 4] - test W_FF(s)', ...
    '[TEST 5] - test Initial Root Guesses','[TEST 6] - test open bisection','[TEST 7] - test closed bisection', ...
    '[TEST 8] - test open dW','[TEST 9] - test closed dW','[TEST 10] - test open AR', ...
    '[TEST 11] - test closed AR'};

    diffs=zeros(total_tests,1);
    passed_tests=zeros(total_tests,1);
    epsilon = test_params.epsilon;   
    s=-10; % s parameter for Laplace transform functions
    
    %fprintf('[BEGINNING UNIT TESTS] - at concentration = %e\n',test_params.conc)
    
    %get Q-matrix representation given the constraints and agonist
    %concentration
    Q_rep = test_params.mechanism.setupQ(test_params.conc);
    lik=ExactLikelihood();
    [specA,eig_valsA,~]=lik.spectral_expansion(Q_rep.Q_AA);           
    expQAA = lik.mat_exponentiation(eig_valsA,specA,test_params.tres);    
    
    % setup functions
    HAA = Hs(s,test_params.tres,Q_rep.Q_AA,Q_rep.Q_FF,Q_rep.Q_AF,Q_rep.Q_FA,test_params.mechanism.kE);
    HFF = Hs(s,test_params.tres,Q_rep.Q_FF,Q_rep.Q_AA,Q_rep.Q_FA,Q_rep.Q_AF,test_params.mechanism.kA);
    WAA=Ws_mex(s,test_params.tres,Q_rep.Q_AA,Q_rep.Q_FF,Q_rep.Q_AF,Q_rep.Q_FA,test_params.mechanism.kA,test_params.mechanism.kE);
    WFF=Ws(s,test_params.tres,Q_rep.Q_FF,Q_rep.Q_AA,Q_rep.Q_FA,Q_rep.Q_AF,test_params.mechanism.kE,test_params.mechanism.kA);
    [open_roots,debug]=asymptotic_roots(test_params.tres,Q_rep.Q_AA,Q_rep.Q_FF,Q_rep.Q_AF,Q_rep.Q_FA,test_params.mechanism.kA,test_params.mechanism.kE,1); 
    a_intervals=debug.intervals.convert();
    [closed_roots,debug]=asymptotic_roots(test_params.tres,Q_rep.Q_FF,Q_rep.Q_AA,Q_rep.Q_FA,Q_rep.Q_AF,test_params.mechanism.kE,test_params.mechanism.kA,1);    
    f_intervals=debug.intervals.convert();
    A_dW=dW_ds(open_roots(1),test_params.tres,Q_rep.Q_AF,Q_rep.Q_FF,Q_rep.Q_FA,test_params.mechanism.kA,test_params.mechanism.kE);
    F_dW=dW_ds(closed_roots(1),test_params.tres,Q_rep.Q_FA,Q_rep.Q_AA,Q_rep.Q_AF,test_params.mechanism.kE,test_params.mechanism.kA);
    a_AR=AR(open_roots,test_params.tres,Q_rep.Q_AA,Q_rep.Q_FF,Q_rep.Q_AF,Q_rep.Q_FA,test_params.mechanism.kA,test_params.mechanism.kE);
    f_AR=AR(closed_roots,test_params.tres,Q_rep.Q_FF,Q_rep.Q_AA,Q_rep.Q_FA,Q_rep.Q_AF,test_params.mechanism.kE,test_params.mechanism.kA);

    [passed_tests(1),diffs(1)] = TestCompare(HAA,p_HAA,epsilon);

    [passed_tests(2),diffs(2)] = TestCompare(HFF,p_HFF,epsilon);
    
    [passed_tests(3),diffs(3)] = TestCompare(WAA,p_WAA,epsilon);
   
    [passed_tests(4),diffs(4)] = TestCompare(WFF,p_WFF,epsilon);

    [passed_tests(5),diffs(5)] = TestCompare(f_intervals,p_f_initial,epsilon); 

    [passed_tests(6),diffs(6)] = TestCompare(open_roots,p_Aroots,epsilon);

    [passed_tests(7),diffs(7)] = TestCompare(closed_roots,p_Froots,epsilon);

    [passed_tests(8),diffs(8)] = TestCompare(A_dW,p_A_dW,epsilon);

    [passed_tests(9),diffs(9)] = TestCompare(F_dW,p_F_dW,epsilon);
    
    %we hae to reorder the MATLAB dimensions for these tests as the 3rd dimension in MATLAB -> 1st
    %dimension in numpy

    [passed_tests(10),diffs(10)] = TestCompare(permute(a_AR,[3,1,2]),p_a_AR,epsilon);

    [passed_tests(11),diffs(11)] = TestCompare(permute(f_AR,[3,1,2]),p_f_AR,epsilon);

    if verbose
    
        % *** SUMMARY OF TEST RESULTS ***

        passed = sum(passed_tests);
        failed = total_tests-passed;

        if sum(passed_tests)==total_tests
        fprintf('[ALL TESTS PASSED] - Asymptotic Root calculations are the same %d tests passed\n\n',total_tests)
        else
        fprintf('\n\n[%i FAILED TESTS]\n\n',failed)
        failed_tests = find(passed_tests==0);
        for i=1:length(failed_tests)
        fprintf('\t%s - [DIFF] %f\n',test_names{failed_tests(i)},diffs(failed_tests(i)))
        end
        end

        fprintf('\n\n[ALL TEST DIFFERENCES] - \n\n')
        for i=1:total_tests
        fprintf('\t%s - [DIFF] %f\n',test_names{i},diffs(i))
        end

    end
    save(test_params.asymptoticOutFile, 'HAA','HFF','WAA','WFF','a_intervals','f_intervals','open_roots','closed_roots','A_dW','F_dW','a_AR','f_AR','test_names','passed_tests','diffs');

end