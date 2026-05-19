function en_diff=singleEnergyDifference(lattice,x,y,J1,J2,K,h)
curr_spin=lattice(x,y);
if curr_spin==0
    en_diff=inf; 
return 
end 

ENERGY=smallNeighborhoodEnergy(lattice,x,y,J1,J2,K,h);

E_current=ENERGY(1);
E_flipped = -E_current;
en_diff = E_flipped - E_current; 
end