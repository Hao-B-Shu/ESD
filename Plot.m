function Plot(varargin)

Para=inputParser;
addOptional(Para,'nk',[0,0;3,1;5,2;7,3;9,4]);
addOptional(Para,'tmin',10^(-13));
addOptional(Para,'P',0.99);
addOptional(Para,'saveDir','');

parse(Para,varargin{:});

tmin=Para.Results.tmin;
nk=Para.Results.nk;
P=Para.Results.P;
saveDir=Para.Results.saveDir;

set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesLineWidth',1.1);

set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultAxesTitleFontSizeMultiplier', 1.05);

set(groot, 'defaultAxesTitleFontWeight','bold');
set(groot, 'defaultAxesFontWeight', 'bold');

set(groot, 'defaultTextInterpreter','latex');

t = logspace(log10(tmin), 0, 100);

%% --------- SESD ----------
figure; hold on;
h1 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [SESD,~,~,~,~] = SESD_NESR_QBER('t',t,'n',n,'k',k,'P',P);
    h1(i) = plot(t, SESD, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
set(gca,'YScale','log');
axis([tmin 1 0 10]);
xlabel('$t$'); ylabel('SESD');
title(sprintf('\\textbf{SESD with respect to $t$, where $P=%g$}',P));
legend(h1,'Location','best','Interpreter','latex');
grid on;
name=sprintf('SESRP%g.eps', P);
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);

%saveas(gcf, fullfile(saveDir, 'SESD.png'));

%% --------- NESR ----------
figure; hold on;
h2 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [~,NESR,~,~,~] = SESD_NESR_QBER('t',t,'n',n,'k',k,'P',P);
    h2(i) = plot(t, NESR, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
axis([tmin 1 0 10])
xlabel('$t$'); ylabel('NESR');set(gca,'YScale','log');
title(sprintf('\\textbf{NESR with respect to $t$, where $P=%g$}',P));
legend(h2,'Location','best','Interpreter','latex');
grid on;
name=sprintf('NESRP%g.eps', P);
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);
%saveas(gcf, fullfile(saveDir, 'NESR.png'));

%% --------- QBER ----------
figure; hold on;
h3 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [~,~,QBER,~,~] = SESD_NESR_QBER('t',t,'n',n,'k',k,'P',P);
    h3(i) = plot(t, QBER, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
axis([tmin 1 -0.005 0.11])
xlabel('$t$'); ylabel('Fundamental QBER');
title(sprintf('\\textbf{Fundamental QBER with respect to $t$, where $P=%g$}',P));
legend(h3,'Location','best','Interpreter','latex');
grid on;
name=sprintf('QBERP%g.eps', P);
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);
%saveas(gcf, fullfile(saveDir, 'QBER.png'));

end