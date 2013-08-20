function fit = fit_experiment(experiment)
    %This fits a model with given data and experimental conditions
    
    %INPUTS - experiment, a struct containing the model, data and
    %experimental parameters
    
    %OUTPUTS - a mechanism with the fitted parameters
    
    lik=DCProgsExactLikelihood();   
    splx=Simplex();
    tic;
    [min_function_value,min_parameters,iterations,rejigs,errors,~]=splx.run_simplex(lik,experiment.model.getParameters(true),experiment);
    toc;
    %transfform the parameters back to real space 
    if experiment.parameters.fit_logspace
        min_parameters=containers.Map(min_parameters.keys,cellfun(@exp,min_parameters.values));
    end
    
    %set the final parameters on the model
    experiment.model.setParameters(min_parameters);
    
    fit.parameters = experiment.model.getParameters(false);
    fit.likelihood = min_function_value;
    fit.iterations = iterations;
    fit.rejigs = rejigs;
    fit.errors = errors;
    if experiment.parameters.debug_on
        fit.debug = debug;
    end
    
end