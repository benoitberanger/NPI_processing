clear
clc

%% Prepare paths and regexp

imgpath = [ pwd filesep 'img'];

subjectpath_raw = get_subdir_regex(imgpath,'NPI');
subjectpath = remove_regex(subjectpath_raw,'_/$');
% suj = get_subdir_regex(chemin);
%to see the content
char(subjectpath)

designdir = [ pwd filesep 'secondlevel' filesep 'localizer'];

par.display=0;
par.run=1;


myContrasts = {
    'main effect : rest'
    'main effect : sentence'
    'main effect : psedo_sentence'
    'sentence - rest'
    'rest - sentence'
    'psedo_sentence - rest'
    'rest - psedo_sentence'
    'sentence - psedo_sentence' % 8 <----
    'psedo_sentence - sentence'
    };


myScans = {
    
% fmri exam               'group'
'2015_05_15_NPI_Pilote03' 'nc'
'2015_05_15_NPI_Pilote04' 'nc'
'2015_06_16_NPI_AUDH'     'nc'
'2015_06_16_NPI_MORP'     'prehd'
'2015_06_18_NPI_KOCL'     'prehd'
'2015_06_23_NPI_HUGC'     'nc'
'2015_06_24_NPI_MAZL'     'prehd'
'2015_06_30_NPI_BERK'     'nc'
'2015_07_21_NPI_PERP'     'nc'
'2015_07_24_NPI_JOUM'     'nc'
'2015_07_24_NPI_MALC'     'nc'
'2015_07_28_NPI_PEAR'     'prehd'
'2015_07_29_NPI_TROC'     'prehd'
'2015_07_31_NPI_BAIR'     'nc'
'2015_07_31_NPI_BRUS'     'nc'
'2015_07_31_NPI_NICP'     'nc'
'2015_08_03_NPI_BREH'     'nc'
'2015_08_03_NPI_LAMC'     'nc'
'2015_08_03_NPI_MATT'     'nc'
'2015_08_05_NPI_DAVE'     'nc'
'2015_08_10_NPI_COMR'     'nc'
'2015_08_10_NPI_TOUP'     'nc'
'2015_08_26_NPI_AMAM'     'nc'
'2015_08_26_NPI_LATP'     'nc'
'2015_08_28_NPI_SIXJ'     'prehd'
'2015_08_28_NPI_ZOZM'     'nc'
'2015_09_14_NPI_PECE'     'prehd'
'2015_10_28_NPI_BERD'     'prehd'
'2016_01_08_NPI_BELA'     'prehd'
'2016_01_15_NPI_RAMC'     'prehd'
'2016_02_05_NPI_MICV'     'prehd'
'2016_02_19_NPI_MOSC'     'nc'
'2016_03_07_NPI_BRAA'     'nc'
'2016_04_08_NPI_BERE'     'prehd'
'2016_05_27_NPI_DIBS'     'prehd'
'2016_10_21_NPI_KOKP'     'prehd'
'2017_07_07_NPI_BRIA'     'prehd'

};

grp_nc = [];
grp_prehd = [];

for s = 1 : size(myScans)
    
    current_imagepath = get_subdir_regex(imgpath,myScans{s,1},'stat','localizer');
    
    current_contrastfile = get_subdir_regex_files(current_imagepath,'con_0008.nii');
    
    if strcmp(myScans{s,2},'nc')
        grp_nc = [ grp_nc; current_contrastfile ]; %#ok<*AGROW>
    elseif strcmp(myScans{s,2},'prehd')
        grp_prehd = [ grp_prehd; current_contrastfile ];
    end
    
end

char(grp_nc), size(grp_nc)
char(grp_prehd), size(grp_prehd)


%% Fill the 2nd lvl design job

matlabbatch{1}.spm.stats.factorial_design.dir = {designdir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans = grp_nc;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans = grp_prehd;
matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


spm('defaults', 'FMRI');

% spm_jobman('interactive',job1);
% spm('show');


%% Prepare the job for estimation

do_delete(designdir,0)
mkdir(designdir)
spm_jobman('run', matlabbatch);


%% Estimate

fspm = get_subdir_regex_files( designdir , 'SPM.mat' , 1 )

job2{1}.spm.stats.fmri_est.spmmat = fspm ;
job2{1}.spm.stats.fmri_est.write_residuals = 0;
job2{1}.spm.stats.fmri_est.method.Classical = 1;


%%


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

