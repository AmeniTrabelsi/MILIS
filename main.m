close all
clear
clc

%Load generated synthetic Data

load('SyntheticData.mat');

Labels=[Data.Bags(:).Label];

Pos=find(Labels+1);
Neg=find(1-Labels);


Ratio=0.7;

% Split Data into Train and Test Data
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

% Compute Distance between instances
for i=1:length(Insts)
    for j=1:length(Insts)
        Dists(i,j)=sqrt(sum( (Insts(i,:)-Insts(j,:)).^2 ));
    end
end

% Compute Lambda and Beta
SortedDists=sort(Dists,2);
Best_Sig=mean(SortedDists(:,20));

lambda=1/(Best_Sig^2);
beta=lambda;


% Train
[IPs, W ]=MILIS_Train(TrainData,TestData,beta,lambda);

% Test
[Acc,Conf,LblDiff]=MILIS_Test(TestData,TrainData,IPs,W,lambda)


















