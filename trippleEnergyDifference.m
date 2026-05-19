function [en_diff,x_1,y_1,x_2,y_2]=trippleEnergyDifference(lattice,x,y,J1,J2,K,h)
width=size(lattice,1);
height=size(lattice,2);
%
wrap_x=@(a) mod(a-1,width)+1;
wrap_y=@(a) mod(a-1,height)+1;
%
curr_spin=lattice(x,y);
%check exception%
if curr_spin==0
    en_diff=inf;
    x_1=x; y_1=y;
    x_2=x; y_2=y;
    return
end

full_wrap=[wrap_x(x+2) y; wrap_x(x+1) wrap_y(y+1);
           wrap_x(x-1) wrap_y(y+1);wrap_x(x-2) y; 
           wrap_x(x-1) wrap_y(y-1);wrap_x(x+1) wrap_y(y-1)];

N=size(full_wrap,1);
step=(-1)^(randi(2)-1);
rand_plaq_1=randi(N);
rand_plaq_2=mod(rand_plaq_1-1+step,N)+1;

x_1=full_wrap(rand_plaq_1,1);
y_1=full_wrap(rand_plaq_1,2);

x_2=full_wrap(rand_plaq_2,1);
y_2=full_wrap(rand_plaq_2,2);

plaquette=[x,y;x_1,y_1;x_2,y_2];
inSite=neighbors(lattice,plaquette,0);
finSite=neighbors(lattice,plaquette,1);
%
E_i=neighborhoodEnergy(inSite,J1,J2,K,h);
E_f=neighborhoodEnergy(finSite,J1,J2,K,h);
%
en_diff=E_f-E_i;
end