% Parameter list
J1_list = 0;
J2_list = 0:0.1:1.5;
K_list  = 0:0.1:1;
h_list  =0;

% Build parameter table
[J1g,J2g,Kg,hg] = ndgrid(J1_list,J2_list,K_list,h_list);

params = table( ...
    J1g(:),J2g(:),Kg(:),hg(:), ...
    'VariableNames',{'J1','J2','K','h'});

nRuns = height(params);


% Output directory
outdir = 'C:\Users\Desktop\FILENAME';
if ~exist(outdir,'dir')
    mkdir(outdir)
end

% Parallel execution
parpool;
parfor i = 1:nRuns
    p = params(i,:);

    fprintf('Running %d / %d : J2 = %.2f\n', i, nRuns, p.J2);

    fname = sprintf( ...
        'PT_J1_%g_J2_%g_K_%g_h_%g.mat', ...
        p.J2,p.J2,p.K,p.h);

    run_PLAQ_ISING_PT_saveall( ...
        p.J2, p.J2, p.K, p.h, ...
        fullfile(outdir,fname));
end

fprintf('All simulations completed.\n');
