function [ Feat ] = DataMinHaussDorff( Insts,IP,InstPerBag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    
    NbInst=size(Insts,1);
    IPMat=repmat(IP,NbInst,1);
    
    Dists=sqrt(sum((Insts-IPMat).^2,2));
    Dists=reshape(Dists,InstPerBag,NbInst/InstPerBag)';
    
    
    Feat=min(Dists,[],2);
    


end

