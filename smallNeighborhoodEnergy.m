function [en,en_tot]=smallNeighborhoodEnergy(lattice,x,y,J1,J2,K,h)
width=size(lattice,1);
height=size(lattice,2); 
wrap_x=@(x) mod(x-1,width)+1;
wrap_y=@(y) mod(y-1,height)+1;
curr_spin=lattice(x,y);

if curr_spin==0
    en=inf; 
return 
end 

top_right=lattice(wrap_x(x+1),wrap_y(y+1));
top_left=lattice(wrap_x(x-1),wrap_y(y+1)); 
bot_right=lattice(wrap_x(x+1),wrap_y(y-1));
bot_left=lattice(wrap_x(x-1),wrap_y(y-1));
right=lattice(wrap_x(x+2),y); 
left=lattice(wrap_x(x-2),y);

J1_part=-J1*curr_spin*(left+right);
J2_part=-J2*curr_spin*(top_left+top_right+bot_right+bot_left); 
K_part=-K*curr_spin*(top_right*top_left+ bot_right*bot_left+ ...
                     top_right*right+bot_right*right+ ...
                     top_left*left+bot_left*left); 
h_part=-h*curr_spin; 

if height==2 
J2_part=J2_part/2;
K_part=K_part/2;
if width==2 
  J1_part=0;
end 
end 
en=J1_part+J2_part+K_part+h_part;
en_tot=(J1_part+J2_part)/2+K_part/3+h_part;
end