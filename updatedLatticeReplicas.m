function [res,rate]=updatedLatticeReplicas(replicas,beta,J1,J2,K,h)
    res=replicas;
    en=zeros(1,length(res));

for k=1:length(res)
    en(k)=totalEnergy(res{k},J1,J2,K,h);
end

    accepts=0;
    attempts=0;
  
    % decide swap pattern randomly
    if rand() < 0.5
        idx = 1:2:(length(res)-1);
    else
   
        idx = 2:2:(length(res)-1);
    end
    

for i=idx
    beta_diff=beta(i)-beta(i+1);
    en_diff=en(i+1)-en(i);
    del=beta_diff*en_diff;
    attempts = attempts + 1;

    
    if del < 0 || rand() < exp(-del)

    temp=res{i+1};
    res{i+1}=res{i};
    res{i}=temp;
    
    temp_e=en(i+1);
    en(i+1)=en(i);
    en(i)=temp_e;
    accepts=accepts+1;
    end

end
rate=accepts/attempts;
end