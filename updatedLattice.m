function [up_lat,accepted]=updatedLattice(lattice,beta,J1,J2,K,h)
width=size(lattice,1);
height=size(lattice,2);
up_lat=lattice;
accepted=0;
for i=1:(width*height)
    x=randi(width);
    y=randi(height);

    if up_lat(x,y)==0 
        continue;
    end
    
    dE=singleEnergyDifference(up_lat,x,y,J1,J2,K,h);
     if dE<=0 || rand()<exp(-beta*dE) 
        up_lat(x,y)=-up_lat(x,y);
        accepted = accepted + 1;
    end    
end
end

%Turn on for mixing some larger secondary interactions

    % if rand()<0.5 && up_lat(x,y) ~= 0
    % [dE,x_1,y_1,x_2,y_2]=trippleEnergyDifference(up_lat,x,y,J1,J2,K,h);
    %  if dE<=0 || rand()<1/(1+exp(beta*dE))
    %     up_lat(x,y)=-up_lat(x,y);
    %     up_lat(x_1,y_1)=-up_lat(x_1,y_1);
    %     up_lat(x_2,y_2)=-up_lat(x_2,y_2);
    %    %display('1');
    % end
    % else