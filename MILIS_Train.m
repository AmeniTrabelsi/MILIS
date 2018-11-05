function [ IPs, W, IterIPs,IterW,lambda ] = MILIS_Train( TrainDataSF,TestDataSF,beta,lambda )



    
    Data=TrainDataSF;
    
    LandMineNbInstPerBag=5;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % All negative instances
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    NInsts=[];
    for i=1:Data.NbBags
        if Data.Bags(i).Label==-1
            NInsts=[NInsts;Data.Bags(i).Insts];
        end
    end
    
    Insts=[];
    for i=1:Data.NbBags
        Insts=[Insts;Data.Bags(i).Insts];
    end
    
    PInsts=[];
    for i=1:Data.NbBags
        if Data.Bags(i).Label==1
            PInsts=[PInsts;Data.Bags(i).Insts];
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %Select IPs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    

    
    IPs=ones(Data.NbBags,1);
    for i=1:Data.NbBags
        
        if Data.Bags(i).Label==1
            mn=1e6;
            for j=1:Data.Bags(i).NbInst
                Pr=kde(Data.Bags(i).Insts(j,:),NInsts,beta);
                if Pr<mn
                    mn=Pr;
                    ip=j;
                end
            end
        else
            mx=0;
            for j=1:Data.Bags(i).NbInst
                Pr=kde(Data.Bags(i).Insts(j,:),NInsts,beta);
                if Pr>mx
                    mx=Pr;
                    ip=j;
                end
            end
        end
        IPs(i)=ip;
    end
    
    
    %IPs=randi(5,Data.NbBags,1);

    
%     IPs=[];
%     for i=1:Data.NbBags
%         IPs=[IPs; randi(Data.Bags(i).NbInst)]
%     end
%     
    Dists=zeros(Data.NbBags);
    for i=1:Data.NbBags
        Dists(:,i)=DataMinHaussDorff(Insts,Data.Bags(i).Insts(IPs(i,1),:),LandMineNbInstPerBag);
    end

    
    SortedDists=sort(Dists,2);
    Best_Sig=mean(SortedDists(:,5))
    
    %lambda=1/(Best_Sig^2);
    
    
    S=exp(-lambda*(Dists.^2));
    
    
    figure, scatter(PInsts(:,1),PInsts(:,2),'r')
    hold on, scatter(NInsts(:,1),NInsts(:,2),'c')
    for i=1: Data.NbBags
        hold on; scatter (Data.Bags(i).Insts(IPs(i,1),1),Data.Bags(i).Insts(IPs(i,1),2),100,'k*');
    end
    
    
         
	NbIter=6;
    IterCounter=0;
    
    Labels = [Data.Bags(:).Label];
    
    %rmdir(strcat('..\LM_MILIS_IPs'))
    %mkdir(strcat('..\LM_MILIS_IPs'))
    
    ChangedIPs=[];
    
    IterIPs=[];
    IterW=[];

    while IterCounter<NbIter
        
        OldIPs=IPs;
        

        Mdl = fitcsvm(S,Labels);

        W = Mdl.Beta;
        
        

        
        IterW=[IterW W];
        

        
        [S,IPs]=InstUpdate(Data,S,IPs,W,lambda,Insts);

        figure, scatter(PInsts(:,1),PInsts(:,2),'r')
        hold on, scatter(NInsts(:,1),NInsts(:,2),'c')
        for i=1: Data.NbBags
            hold on; scatter (Data.Bags(i).Insts(IPs(i,1),1),Data.Bags(i).Insts(IPs(i,1),2),100,'k*');
        end
        
        IterIPs=[IterIPs IPs];
        
        IterCounter = IterCounter+1;
        
        %find(IPs~=OldIPs)'
        
        ChangedIPs=[ChangedIPs find(IPs~=OldIPs)'];
        
        %TestCurrModel( TestDataSF,TrainDataSF,IPs,W,lambda,IterCounter);
        
        
        [res1,lbls]=MILIS_Test(TestDataSF,TrainDataSF,IPs,W,lambda);
        
        res1
        
        
        
        if isequal(IPs,OldIPs)
            break;
        end
        
    
    end
 


end

