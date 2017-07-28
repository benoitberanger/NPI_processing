%% Fetch contrasts & prepare groups

designdir = [ pwd filesep 'secondlevel' filesep 'localizer'];

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

grp_nc = [];
grp_prehd = [];

for s = 1 : size(examList)
    
    current_imagepath = get_subdir_regex(imgpath,examList{s,1},'stat','localizer');
    
    current_contrastfile = get_subdir_regex_files(current_imagepath,'con_0008.nii');
    
    if strcmp(examList{s,2},'nc')
        grp_nc = [ grp_nc; current_contrastfile ]; %#ok<*AGROW>
    elseif strcmp(examList{s,2},'prehd')
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


%% Estimate & write contrasts

fspm = get_subdir_regex_files( designdir , 'SPM.mat' , 1 )

secondlevel_estimate_and_write_contrasts

