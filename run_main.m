function [rt_cross_two, node_cross_two, rt_cross, node_cross, rt_two,  node_two] = run_main(model, simu_type, file_identifier, save_simu)
%
% [rt_cross_two, node_cross_two, rt_cross, node_cross, rt_two,  node_two] = run_main(model, simu_type, file_identifier, save_simu)
%
% model: 1 = EM; 2 = PE;
% simu_type: 1 = two object cost; 2 = example plots; 3 = neuroimaging
%
% file_identifier: identifier (date string) of the file which contains the parameter struct, templates and input images. Note
% that code allows to override this setting by using the function
% set_paravalues(para, network, paraname, value).
%
% save_simu: it exists the parameters, templates and images will be saved under a new name. If it
% has the value one no simulation will be completed
%
% rt_... returns reaction times
% node_... returns the index of the winning template node.
%



simu_values = load(identifier2filename(model,file_identifier));

para = simu_values.para;
two = simu_values.two;
cross = simu_values.cross;
cross_two = simu_values.cross_two;
two_temp = simu_values.two_temp;
cross_temp = simu_values.cross_temp;
identifier = simu_values.identifier;


mod_para = para;

% In the section parameter read in the previous lines can be
% overrriden in order to play around with the parameters.
% Once the user decides that the new parameters are good,
% the parameters can be saved in a new file using save_only and save_par.
% Example for correctly changing parameter values:
% mod_para = set_paravalues(mod_para, 'CN', 'sigma', 1e-4);



if ~isequal(para, mod_para)
    warning('The parameters were changed!');
    para = mod_para;
end

if exist('save_paras') && save_simu == 1
    identifier = datestr(now,30);
    s = strfind(identifier, ' ');
    identifier(s) = '_';
    filename = identifier2filename(model,identifier);
    save(filename,'para','cross_temp', 'two_temp', 'cross_two', 'two', 'cross', 'identifier');
    return
end


templates(1,:,:) = cross_temp;
templates(2,:,:) = two_temp;

if simu_type == 1
    %%RANDOM NUMBER
    %%Simulation of a number of trials for each condition, cross+two, cross, two
    rng(1);
    number_trials = 20;
    rt_cross_two = zeros(number_trials,1);
    node_cross_two = zeros(number_trials,1);
    
    rt_cross = zeros(number_trials,1);
    node_cross = zeros(number_trials,1);
    
    rt_two = zeros(number_trials,1);
    node_two = zeros(number_trials,1);
    
    seeds = randi(3*number_trials,3*number_trials,1);
    
    parfor i=1:number_trials
        [rt_cross_two(i), node_cross_two(i)] = run_saim(model, para, templates, cross_two, seeds(i));
    end
    
    parfor i=1:number_trials
        [rt_cross(i), node_cross(i)] = run_saim(model, para, templates, cross, seeds(i+number_trials));
    end
    
    for i=1:number_trials
        [rt_two(i), node_two(i)]= run_saim(model, para, templates, two, seeds(i+2*number_trials));
    end
    
    return
end

if simu_type == 2 || simu_type == 3
    rng(para.rand_seed);
    seeds = randi(200,3,1);
    %Single trial simulations for figures plus plotting in show_results
    
    para.stop_at_threshold = 0;
    
    [rt_cross_two, node_cross_two,  y_KN_cross_two, y_CN_cross_two, input_SN_cross_two, input_CN_cross_two, input_KN_cross_two, y_SN_cross_two] = run_saim(model, para, templates, cross_two, seeds(1));
    [rt_cross, node_cross, y_KN_cross, y_CN_cross, input_SN_cross, input_CN_cross, input_KN_cross, y_SN_cross] = run_saim(model, para, templates, cross, seeds(2));
    [rt_two, node_two, y_KN_two, y_CN_two, input_SN_two, input_CN_two, input_KN_two, y_SN_two]= run_saim(model, para, templates, two, seeds(3));
    
    if para.stop_at_threshold == 1
        max_time = max([rt_cross_two rt_two rt_cross]);
    else
        max_time = para.duration;
    end
    
    if simu_type == 2
        show_image_temp(cross, two, cross_two, cross_temp, two_temp)
        show_results(max_time, y_KN_cross_two(1:max_time,:), y_CN_cross_two,'Two objects: cross and two', model,0);
        show_results(max_time, y_KN_cross(1:max_time,:), y_CN_cross,'Single object: cross', model,0);
        show_results(max_time, y_KN_two(1:max_time,:), y_CN_two,'Single object: two', model, 0);
        fprintf(1, 'RT_cross: %d  RT_two: %d  RT_cross_two: %d \n', rt_cross, rt_two, rt_cross_two);
        
    else
        show_neuroimaging(input_SN_cross_two, input_CN_cross_two, input_KN_cross_two, y_SN_cross_two, y_CN_cross_two, y_KN_cross_two, model, 0, 'cross_two')
        show_neuroimaging(input_SN_cross_two, input_CN_cross_two, input_KN_cross_two, y_SN_cross_two, y_CN_cross_two, y_KN_cross_two, model, 1, 'cross_two')
    end
end


