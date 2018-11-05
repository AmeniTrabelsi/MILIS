function [res,Conf,LblDiff]=MILIS_Test(TestData,TrainData,IPs,W,Lambda)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Lbls=[];
    Conf=[];
    
%     TrainLbls=[TrainData.Bags(:).Label];
%     
%     NegLbls=find(TrainLbls-1);
%     PosLbls=find(TrainLbls+1);
%     
%     NbNeg=max(NegLbls)-min(NegLbls);
%     NbPos=max(PosLbls)-min(PosLbls);
%     
%     SelectedNeg=randperm(NbNeg,NbPos);
%     
%     NegIPs=sort(NegLbls(SelectedNeg));
%     
%     IPsIdx=[PosLbls NegIPs];
    
    
    for i=1:TestData.NbBags
        d=[];
        for j=1:TrainData.NbBags
            d=[d minHausdorff(TestData.Bags(i).Insts,TrainData.Bags(j).Insts(IPs(j),:))];
        end
        S=exp(-Lambda*(d.^2));
        
        %f=sum(W(IPsIdx).*S(IPsIdx)');
        f=sum(W.*S');
        
        Conf=[Conf;f];
        
        Lbls=[Lbls 2*(f>=0)-1];
        
    end
    
    TrueLbls=[TestData.Bags(:).Label];
    
    res=sum(TrueLbls==Lbls)/length(TrueLbls);
    
    LblDiff=(TrueLbls~=Lbls)';


end

