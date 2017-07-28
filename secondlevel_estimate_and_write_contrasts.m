%% Estimate : params

job2{1}.spm.stats.fmri_est.spmmat = fspm ;
job2{1}.spm.stats.fmri_est.write_residuals = 0;
job2{1}.spm.stats.fmri_est.method.Classical = 1;


%% Estimate : process

spm_jobman('run', job2);


%% Contraste

contrast.names = {
    'nc'
    'prehd'
    'nc - prehd'
    'prehd - nc'
    }';

contrast.values = {
    [1 0]
    [0 1]
    [1 -1]
    [-1 1]
    }';

contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));
par.delete_previous=1;
par.run=1;


%% Write contrasts

job_first_level_contrast(fspm,contrast,par)
