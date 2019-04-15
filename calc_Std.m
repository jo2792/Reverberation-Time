close all
clear
clc

% Lade Messwerte
load("data_reverberation.mat");

% Konvertiere Tabellendaten(RT60) in Array
A = table2array(data.table);


Standardabweichung=[];
Mittel= [];

    for idy = 1:18
        Standardabweichung(idy,1) = std(A(idy,(2:13)));
        Mittel(idy,1) = mean(A(idy,(2:13)));
    end

stats_reverberationtime_wo_Absorb = table(Mittel,Standardabweichung)

    for idy = 1:18
        Standardabweichung(idy,1) = std(A(idy,(14:25)));
        Mittel(idy,1) = mean(A(idy,(14:25)));
    end
    
stats_reverberationtime_w_Absorb = table(Mittel,Standardabweichung)