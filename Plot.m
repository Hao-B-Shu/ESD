function Plot(tmin, tmax, nk, saveDir)

set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesLineWidth',1.1);

set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultAxesTitleFontSizeMultiplier', 1.05);

set(groot, 'defaultAxesTitleFontWeight','bold');
set(groot, 'defaultAxesFontWeight', 'bold');

set(groot, 'defaultTextInterpreter','latex');

t = logspace(log10(tmin+10^(-13)), log10(tmax), 100);

%% --------- SESD ----------
figure; hold on;
h1 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [SESD,~,~] = SESD_NESR_QBER('t',t,'n',n,'k',k);
    h1(i) = plot(t, SESD, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
set(gca,'YScale','log');
axis([tmin tmax 0 10]);
xlabel('$t$'); ylabel('SESD');
title('\textbf{SESD with respect to $t$ under different $n$ and $k$}');
legend(h1,'Location','best');
grid on;
print(gcf, [fullfile(saveDir, 'SESD') '.eps'], '-depsc', '-vector');
%saveas(gcf, fullfile(saveDir, 'SESD.png'));

%% --------- NESR ----------
figure; hold on;
h2 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [~,NESR,~] = SESD_NESR_QBER('t',t,'n',n,'k',k);
    h2(i) = plot(t, NESR, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
axis([tmin tmax 0 10])
xlabel('$t$'); ylabel('NESR');set(gca,'YScale','log');
title('\textbf{NESR with respect to $t$ under different $n$ and $k$}');
legend(h2,'Location','best');
grid on;
print(gcf, [fullfile(saveDir, 'NESR') '.eps'], '-depsc', '-vector');
%saveas(gcf, fullfile(saveDir, 'NESR.png'));

%% --------- QBER ----------
figure; hold on;
h3 = gobjects(size(nk,1),1);
for i = 1:size(nk,1)
    n = nk(i,1);
    k = nk(i,2);
    [~,~,QBER] = SESD_NESR_QBER('t',t,'n',n,'k',k);
    h3(i) = plot(t, QBER, 'DisplayName', sprintf('$n$=%d, $k$=%d', n, k));
end
hold off;
set(gca,'XScale','log');
axis([tmin tmax 0.01 0.11])
xlabel('$t$'); ylabel('QBER');
title('\textbf{QBER with respect to $t$ under different $n$ and $k$}');
legend(h3,'Location','best');
grid on;
print(gcf, [fullfile(saveDir, 'QBER') '.eps'], '-depsc', '-vector');
%saveas(gcf, fullfile(saveDir, 'QBER.png'));

end