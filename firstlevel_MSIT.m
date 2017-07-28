%% Get files paths

dfonc_msit = get_subdir_regex_multi(subjectpath,'MSIT$') % ; char(dfonc{:})


%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

msit_onsetfile = get_subdir_regex_files(cleanpath,'msit',1)


%% Specify model

j = job_first_level_specify(dfonc_msit,msitdir,msit_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(msitdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : Cross'
'main effect : C0'
'main effect : C1'
'C0 - Cross'
'Cross - C0'
'C1 - Cross'
'Cross - C1'
'C0 - C1'
'C1 - C0'

}';
contrast.values = {
    [ 1 0 0 ]
    [ 0 1 0 ]
    [ 0 0 1 ]
    [ -1 1 0 ]
    [ 1 -1 0 ]
    [ -1 0 1 ]
    [ 1 0 -1 ]
    [ 0 1 -1 ]
    [ 0 -1 1 ]
    }';
contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));

par.delete_previous=1;


%% Estimate contrast : all runs

par.sessrep = 'none';
j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
par.delete_previous=0;

