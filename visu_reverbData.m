function visu_reverbData(measure, mode,freq, Nr, revInfo)

if nargin== 0
    measure = 1;
    freq = 1;
    Nr = 4; %'all'
    mode = 'both'; %'approx' 'both' 'pure'
    revInfo = 1;
end




%Alle Messungen einer Frequenz plotten
if strcmp(Nr,'all')
    Nr = 1:12;
end

% Für Absorberfall Daten wählen
if measure == 2
    Nr = Nr+12;
end
idx = Nr;

% Lade Messwerte
load("data_reverberation.mat");
warning('off')

fig = figure();
ax = axes(fig);
ax.XLabel.String = "Zeit [s]";
ax.YLabel.String = "Pegel [dB]";
%ax.Title.String = "Messdaten Hallraummessung";

for idx=idx
    hold on
    y = data.signal.(data.Messungen(idx))(:,freq);
    disp(data.Messungen(idx))
    x= linspace(0,1000*(length(y)-1)/data.fs,length(y))';
    if strcmp(mode,"pure") || strcmp(mode,"both")
        plot(ax,x,y)
    end
    
    p=polyfit(x,y,8);
    x= linspace(0,1000*(length(y)-1)/data.fs,length(y)*1000)';
    y= polyval(p,x);
    if strcmp(mode,"approx") || strcmp(mode,"both")
        
        plot(ax,x,y)
        
    end
    
end

if revInfo == 1
    % 10 und -40 Punkt finden
    P_10  = find(round(y,3)==-10);
    if isempty(P_10)
        P_10 = find(round(y,2)==-10);
    end
    
    P_40    = find(round(y,3)==-40);
    
    if isempty(P_40)
        P_40 = find(round(y,2)==-40);
    end
    
    P_10 = P_10(ceil(end/4));
    P_40 = P_40(ceil(end/4));
    % Zeitdauer berechnen
    
    duration_Samp   = P_40-P_10;
    duration_s = (6/3)*duration_Samp/data.fs;
    
    plot([0 P_10/data.fs P_10/data.fs],[-10 -10 -70],'k')
    plot([0 P_40/data.fs P_40/data.fs],[-40 -40 -70],'k')
    plot([P_10/data.fs P_40/data.fs],[-40 -40],'color','r',...
        'LineWidth',2)
    text(P_10/data.fs+0.5, -42, "RT30 = ")
    text(P_10/data.fs+0.5, -45, duration_s*(3/6) + " s")
end

xlim([0 15])

hold off
warning('on')
end




