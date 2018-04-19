clc;
clear all;

readFile = 'Dataset.xlsx';
sheetTrain = 1;
% xlRange = 'A1:C20';
[dataTrain,class] = xlsread(readFile,sheetTrain);
% sheetTest = 1;
% [dataTest,class] = xlsread(readFile,sheetTest);


%atribut yang dihitung
atribut =4;


nDataTrain = size(dataTrain,1);
% nDataTest = size(dataTest,1);
%nilai k KCrossValid
kFold = 7;
%jumlah data per fold
nDataPerFold = ceil(nDataTrain/kFold);


%% pembagian data Train sebanyak K fold
cellFold = cell(kFold,1);
kk = 1;
for i=1:kFold
    temp=[];
    j= 1;
    
    while (j <= nDataPerFold) && (kk <= nDataTrain)
        temp = [temp;dataTrain(kk,:)];
        j= j+1;
        kk= kk+1;
    end
    
    cellFold{i,1}=temp;
end

%% 
%nilai k dari KNN
tabPerformansi =[];
k = 70;
while k <= 81
    disp('nilai K sekarang = ')
    disp(k)
    pointerDataTrain =1;
    tabAkurasi =[];
    for i = 1:kFold
        %% iterasi perubahan data validasi (fold ke-i sebagai validasi)
        dataTrainTemp = [];
        dataValidation = cellFold{i,1};
        j=1;
        while j <= kFold
            if(i==j)
                j=j+1;
            end
            if( j<= kFold)
                dataTrainTemp = [dataTrainTemp;cellFold{j,1}];
            end
            j = j+1;
        end

        %% perhitungan kNN
        nDataValidation = size(dataValidation,1);
        nDataTrainTemp = size(dataTrainTemp,1);
        for ii = 1:nDataValidation
            y = dataValidation(ii,:);
            tabEuclid=[];
            for jj = 1:nDataTrainTemp
                x = dataTrainTemp(jj,:);
                [euclid,class] = euclideanDist(x,y,atribut);%x = data train, y = data test, 4 = jumlah atribut
                tabEuclid = [tabEuclid;euclid,class,jj];

            end

            %sort dengan columns 1 sebagai nilai depend nya
            sorted = sortrows(tabEuclid,1);

            %memasukkan nilai similar tertinggi atau jarak terpendek ke tabel baru
            tabNearest = [];
            for jj= 1:k
                tabNearest = [tabNearest; sorted(jj,:)];
            end

            %menghitung jumlah kelas nol dan satu, untuk mencari kelas dominan
            nSatu = sum(tabNearest(:,2)==1);
            nNol = sum(tabNearest(:,2)==0);
            if nNol > nSatu
                dataValidation(ii,5) = 0;
            elseif nNol < nSatu
                dataValidation(ii,5) = 1;
            end

        end
        disp('Udah masuk Fold test ke -')
        disp(i)
        %%
        jumBenar = 0;
        akurasi = 0;
        %%hitung akurasi
        for ii=1:nDataValidation
            if(dataValidation(ii,5)==dataTrain(pointerDataTrain,5))
                jumBenar = jumBenar + 1;
            end
            pointerDataTrain = pointerDataTrain +1;
        end
        akurasi = jumBenar/nDataValidation;
        tabAkurasi = [tabAkurasi;akurasi];


    end
    performansi = mean(tabAkurasi)*100;
    disp('PERFORMANSI DARI ALGORITMA KNN INI ADALAH')
    disp(performansi)
    tabPerformansi = [tabPerformansi;k,performansi];
    % untuk iterasi k agar selalu ganjil
    k = k+2;
end

a = (tabPerformansi(:,1));
b = (tabPerformansi(:,2));
plot(a,b);
title('Pengaruh K terhadap performansi')
xlabel('K') % x-axis label
ylabel('Performansi') % y-axis label