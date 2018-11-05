clc
clear
close all


GenPos=@() mvnrnd([4 4],[1 0;0 1]);
GenNeg=@() unifrnd([-8 -8],[0 0]);
%GenNeg=@() mvnrnd([-2 -2],[0.25 0;0 0.25]);



BC=0;

for i=1:100
    
    d=GenPos();
    for j=1:4
        d=[d;GenNeg()];
    end
    
    BC=BC+1;
    
    Data.Bags(BC).Insts=d;
    Data.Bags(BC).NbInst=5;
    Data.Bags(BC).Label=1;
    
    
end



for i=1:100
    
    d=[];
    for j=1:5
        d=[d;GenNeg()];
    end
    
    BC=BC+1;
    
    Data.Bags(BC).Insts=d;
    Data.Bags(BC).NbInst=5;
    Data.Bags(BC).Label=-1;
    
    
end




save('SyntheticData.mat','Data');


