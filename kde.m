function [v]=kde(x,data,beta)

    [k,~]=size(data);
    xd=repmat(x,k,1);
    v=sum(exp(-beta*sum((xd-data).^2,2)))/k;
    
end
