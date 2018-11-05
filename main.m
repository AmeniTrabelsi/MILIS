close all
clear
clc

%GenSynth

load('SyntheticData.mat');
% load('D:\Users\ameni\Classes\Test_SyntheticData\SynthDataTest2.mat')
% 
% for i=21:40
%     SynthData.Bags(i).Label=-1;
% end

% Data=SynthData;
Labels=[Data.Bags(:).Label];

Pos=find(Labels+1);
Neg=find(1-Labels);


Ratio=0.7;


TrainPosIdx=round(0.6*length(Pos));
TrainNegIdx=round(0.6*length(Neg));


Test= [Pos(TrainPosIdx+1:end) Neg(TrainNegIdx+1:end)];
Train= [Pos(1:TrainPosIdx) Neg(1:TrainNegIdx)];

TrainData.Bags=Data.Bags(Train);
TrainData.NbBags=length(Train);
TestData.Bags=Data.Bags(Test);
TestData.NbBags=length(Test);


Insts=[];
for i=1:TrainData.NbBags
    Insts=[Insts;TrainData.Bags(i).Insts];
end

scatter(Insts(:,1),Insts(:,2))


for i=1:length(Insts)
    for j=1:length(Insts)
        Dists(i,j)=sqrt(sum( (Insts(i,:)-Insts(j,:)).^2 ));
    end
end


SortedDists=sort(Dists,2);
Best_Sig=mean(SortedDists(:,20));

lambda=1/(Best_Sig^2);
beta=lambda;



[IPs, W ]=MILIS_Train(TrainData,TestData,beta,lambda);

[Acc,Conf,LblDiff]=MILIS_Test(TestData,TrainData,IPs,W,lambda)


















