clc;
clear all;

readFile = 'Dataset.xlsx';
sheetTrain = 1;
% xlRange = 'A1:C20';
[dataTrain,class] = xlsread(readFile,sheetTrain);
sheetTest = 2;
[dataTest,class] = xlsread(readFile,sheetTest);

%nilai k dari KNN
k = 79;

nDataTrain = size(dataTrain,1);
nDataTest = size(dataTest,1);

%%
for i = 1:nDataTest
    y = dataTest(i,:);
    tabEuclid=[];
    for j = 1:nDataTrain
        x = dataTrain(j,:);
        [euclid,class] = euclideanDist(x,y,4);%x = data train, y = data test, 4 = jumlah atribut
        tabEuclid = [tabEuclid;euclid,class,j];
        
    end
    
    %sort dengan columns 1 sebagai nilai depend nya
    sorted = sortrows(tabEuclid,1);
    
    %memasukkan nilai similar tertinggi atau jarak terpendek ke tabel baru
    tabNearest = [];
    for j= 1:k
        tabNearest = [tabNearest; sorted(j,:)];
    end
    
    %menghitung jumlah kelas nol dan satu, untuk mencari kelas dominan
    nSatu = sum(tabNearest(:,2)==1);
    nNol = sum(tabNearest(:,2)==0);
    if nNol > nSatu
        dataTest(i,5) = 0;
    elseif nNol < nSatu
        dataTest(i,5) = 1;
    end
    disp('Udah masuk Data test ke -')
    disp(i)
end





