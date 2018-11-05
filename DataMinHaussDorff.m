function [ Feat ] = DataMinHaussDorff( Insts,IP,InstPerBag )
% Function to create feature vectors

    
    NbInst=size(Insts,1);
    IPMat=repmat(IP,NbInst,1);
    
    Dists=sqrt(sum((Insts-IPMat).^2,2));
    Dists=reshape(Dists,InstPerBag,NbInst/InstPerBag)';
    
    
    Feat=min(Dists,[],2);
    


end

