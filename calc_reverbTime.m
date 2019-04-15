% Wertet Messdaten (WAV) von Nachhallzeitmessungen aus
% Ermittelt aus den Daten die RT30 und extrapoliert dies auf RT60
%
% Author: Jordan Alwon (c) 2019 @TGM Jade Hochschule

close all;
clear;

tic;
% Messdurchgänge - Dateibezeichnungen
    Messungen = ["S1E1a","S1E1b","S1E2a","S1E2b","S1E3a","S1E3b","S2E1a",...
        "S2E1b","S2E2a","S2E2b","S2E3a","S2E3b","S1E1c","S1E1d","S1E2c",...
        "S1E2d","S1E3c","S1E3d","S2E1c","S2E1d","S2E2c","S2E2d","S2E3c",...
        "S2E3d"];

% Terzbandmittenfrequenzen
data.Frequenzen = [100 125 160 200 250 315 400 500 630 800 1000 1250 1600 ...
    2000 2500 3150 4000 5000]';

% Konsolenbenachrichtigung
disp('Bitte warten...')

% Nach Messdatein analysieren
for idy = 1:length(Messungen)
    % Messdaten auslesen und importieren
    file = Messungen(idy);
    dir = "Messdaten\" + file + ".wav";
    
    [signal.(file),fs] = audioread(dir);
    
    warning('off')
    duration_s= [];
    % Nach Frequenzen Analysieren
    for idx = 1:18
        y = signal.(file)(:,idx);
        x= linspace(0,1000*(length(y)-1)/fs,length(y))';
           
        % Annäherungskurve berechnen
        p=polyfit(x,y,8);
        x= linspace(0,1000*(length(y)-1)/fs,length(y)*1000)';
        y= polyval(p,x);
        
        % 10 und -40 Punkt finden
        P_10  = find(round(y,3)==-10);
        if isempty(P_10)
           P_10 = find(round(y,2)==-10);
        end
        
        P_40    = find(round(y,3)==-40);
        
        if isempty(P_40)
           P_40 = find(round(y,2)==-40);
        end
        
        % Einen gefundenen Wert selektieren
        P_10 = P_10(ceil(end/4));
        P_40 = P_40(ceil(end/4));
        
        % Zeitdauer berechnen 
        duration_Samp   = P_40-P_10;
        duration_s(end+1,:) = (6/3)*duration_Samp/fs;
    end
    warning('on')
    
    data.(file) = duration_s;
end

% Speichere relevante Messdaten in einem Struct
data.table = struct2table(data);
data.signal = signal;
data.Messungen = Messungen;
data.fs = fs;

%Konsolenausgabe entfernen
for x = 1:16
        fprintf("\b");
end
    
% Gibt die Auswertung als Tabelle wieder
disp(data.table)

% Exportiert das Daten-Struct als Datei
save('data_reverberation.mat','data')
toc;