function test_args = Test_Setup(paramsFile)
%SetupTests is boilerplate for running the test suite
%RETURNS - a structure with test parameters in it

load(paramsFile);

%test data,concentration and mechanism

%test_args.localpath=getpref('ME','matpath');
dc = DataController;
[~,data]=dc.read_scn_file(data_set);

test_args.conc = concentration;

test_args.mechanism = ModelSetup(paramsFile);

test_args.epsilon = epsilon;

test_args.debug.on=1; %collect the debugging matrices


%file locations
test_args.asymptoticInFile = dcpAsymptoticResultsFile;
test_args.asymptoticOutFile = matAsymptoticResultsFile;
test_args.matrixInFile = dcpMatrixResultsFile;
test_args.matrixOutFile = matMatrixResultsFile;
test_args.setupOutFile = matSetupResultsFile;
test_args.mrInFile = dcpMrResultsFile;
test_args.mrOutFile = matMrResultsFile;
test_args.functionsInFile = dcpFunctionsResultsFile;
test_args.functionsOutFile = matFunctionsResultsFile;
test_args.likelihoodsInFile = dcpLikelihoodsResultsFile;
test_args.likelihoodsOuFile = matLikelihoodsResultsFile;

%rescale intervals into \mu(s)
test_args.data=data;
test_args.data.intervals=data.intervals/1000;


end

