function [nS,IPs]=InstUpdate(Data,S,IPs,W,lambda,Insts)


    nS=S;
    IPs=IPs;
    
    TotalLoss=0;
    
    for i=1:Data.NbBags
        Data.Bags(i).S=S(i,:);
        Data.Bags(i).ConfVal=sum(W.*Data.Bags(i).S');
        TotalLoss=TotalLoss+SVMLoss(Data.Bags(i).Label,Data.Bags(i).ConfVal);
    end
    
    TotalLossCopy=TotalLoss;
    
    for i=1:Data.NbBags
        if SVMLoss(Data.Bags(i).Label,Data.Bags(i).ConfVal)==0
            continue
        end
        TotalLoss=TotalLossCopy;
        for j=1:Data.Bags(i).NbInst
            if j==IPs(i)
                continue;
            end
            
            [NewTotalLoss,nSi,nf]=FeatureUpdate(Data,Data.Bags(i).Insts(j,:),i,...
                S(:,i),W,[Data.Bags(:).ConfVal],TotalLoss,lambda,Insts);
            if NewTotalLoss < TotalLoss
                
                TotalLoss = NewTotalLoss;
                
                nS(:,i)=nSi;
                IPs(i)=j;
                
                for k=1:Data.NbBags
                    Data.Bags(k).ConfVal=nf(k);
                end
                
                
                
            end
            
        end
        
    end
    
end


function [nv,nSi,nf]=FeatureUpdate(Data,nIP,FeatInd,Si,W,f,v,lambda,Insts)

    LandMineNbInstPerBag=5;
    
    nSi=DataMinHaussDorff(Insts,nIP,LandMineNbInstPerBag);
    
    nSi=exp(-lambda*(nSi.^2));
    
    nf=f+W(FeatInd)*(nSi-Si)';
    
    Labels=[Data.Bags(:).Label];
    
    nv= sum(max(0,1-Labels.*nf).^2);
end


function l=SVMLoss(y,f)
    l=max(0,1-y*f)^2;
end



