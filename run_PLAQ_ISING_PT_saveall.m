function run_PLAQ_ISING_PT_saveall(J1,J2,K,h,outfile)

%% lattice constants
LAT_WIDTH=100;
LAT_HEIGHT=100;
SPIN_UP=1;
SPIN_DOWN=-1;
EXC=0;
N_SPIN=floor(LAT_HEIGHT*LAT_WIDTH/2);

%% thermodynamic properties 
KB=1;
T_min=0.01;
T_max=6;
N_T=50;
temp=linspace(T_min,T_max,N_T);
beta=1./(KB*temp);

%% init 
lat_replicas=cell(N_T,1);
for i=1:N_T
    lat_replicas{i}=randomLattice( ...
        LAT_WIDTH,LAT_HEIGHT,SPIN_UP,SPIN_DOWN,EXC);
end

%% parallel tempering loop parameters
MAX_STEPS=2100;
PARALLEL_STEPS=10;
SWEEP_COUNT=1;
BURN_IN=2000;

%% measurement init
raw_magnetization=zeros(MAX_STEPS,N_T);
raw_energies=zeros(MAX_STEPS,N_T);

%% braking mechanism
stabilized=false;

while SWEEP_COUNT<MAX_STEPS && ~stabilized

    for i=1:N_T
        [lat_replicas{i},~]=updatedLattice( ...
            lat_replicas{i},beta(i),J1,J2,K,h);
    end

    if mod(SWEEP_COUNT,PARALLEL_STEPS)==0
        [lat_replicas,~]=updatedLatticeReplicas( ...
            lat_replicas,beta,J1,J2,K,h);
    end

    for k=1:N_T
        raw_energies(SWEEP_COUNT,k)= ...
            totalEnergy(lat_replicas{k,1},J1,J2,K,h);
        raw_magnetization(SWEEP_COUNT,k)= ...
            sum(lat_replicas{k,1},'all')/N_SPIN;
    end

    SWEEP_COUNT=SWEEP_COUNT+1; 
end

%% post measurements
ens=zeros(1,N_T);
mags=zeros(1,N_T);
E2_mean=zeros(1,N_T);

for i=1:N_T
    ens(i)=mean(raw_energies(BURN_IN:MAX_STEPS,i));
    E2_mean(i)=mean(raw_energies(BURN_IN:MAX_STEPS,i).^2);
    mags(i)=mean(raw_magnetization(BURN_IN:MAX_STEPS,i));
end

%Cv=KB*(beta.^2).*(E2_mean-ens.^2);

%% save logs
save(outfile,'-v7.3')

end
