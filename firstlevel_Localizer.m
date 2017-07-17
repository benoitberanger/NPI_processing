clear
clc

%% Prepare paths and regexp

imgpath = [ pwd filesep 'img'];

subjectpath = get_subdir_regex(imgpath,'NPI');
% suj = get_subdir_regex(chemin);
%to see the content
char(subjectpath)

par.display=0;
par.run=1;


%% Get files paths

dfonc_localizer = get_subdir_regex_multi(subjectpath,'Localizer$') % ; char(dfonc{:})

%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

localizer_onsetfile = get_subdir_regex_files(cleanpath,'localizer',1);


%% first level

statdir=r_mkdir(subjectpath,'stat')
localizerdir=r_mkdir(statdir,'localizer')
do_delete(localizerdir,0)
localizerdir=r_mkdir(statdir,'localizer')

par.file_reg = '^sutrf.*nii';

par.TR=2.000;
par.delete_previous=1;


%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j = job_first_level_specify(dfonc_localizer,localizerdir,localizer_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(localizerdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : rest'
'main effect : sentence'
'main effect : psedo_sentence'
'sentence - rest'
'rest - sentence'
'psedo_sentence - rest'
'rest - psedo_sentence'
'sentence - psedo_sentence'
'psedo_sentence - sentence'

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

par.run = 1;
par.display = 0;

par.sessrep = 'none';
j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
par.delete_previous=0;


%% Display


show{1}.spm.stats.results.spmmat = fspm;
show{1}.spm.stats.results.conspec.titlestr = '';
show{1}.spm.stats.results.conspec.contrasts = 1;
show{1}.spm.stats.results.conspec.threshdesc = 'none'; % 'none' 'FWE' 'FDR'
show{1}.spm.stats.results.conspec.thresh = 0.05;
show{1}.spm.stats.results.conspec.extent = 10;
show{1}.spm.stats.results.conspec.conjunction = 1;
show{1}.spm.stats.results.conspec.mask.none = 1;
show{1}.spm.stats.results.units = 1;
show{1}.spm.stats.results.print = false;
show{1}.spm.stats.results.write.none = 1;


%% Display

spm('defaults','FMRI');
spm_jobman('run', show );