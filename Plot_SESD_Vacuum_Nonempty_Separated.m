function Plot_SESD_Vacuum_Nonempty_Separated(varargin)

Para=inputParser;
addOptional(Para,'nmax',9);
addOptional(Para,'P',0.99);
addOptional(Para,'p1',0.99);
addOptional(Para,'saveDir','');
addOptional(Para,'k',NaN);

parse(Para,varargin{:});

nmax=Para.Results.nmax;
P=Para.Results.P;
p1=Para.Results.p1;
saveDir=Para.Results.saveDir;
k=Para.Results.k;

set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesLineWidth',1.1);

set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultAxesTitleFontSizeMultiplier', 1.05);

set(groot, 'defaultAxesTitleFontWeight','bold');
set(groot, 'defaultAxesFontWeight', 'bold');

set(groot, 'defaultTextInterpreter','latex');

n = max(0,k):nmax;   

if isnan(k)
   k = floor(n/2);
   klabel = '$k=\left\lfloor\frac{n}{2}\right\rfloor$';
else
   k=ones(size(n))*k;
   klabel = sprintf('$k=%d$', k(1));
end 

a = zeros(size(n));
b = zeros(size(n));
for i = 1:numel(n)
    [~,~,~,Pkn, Qkn] = SESD_NESR_QBER('n',n(i), 'k',k(i), 'P',P, 'p1',p1);
    a(i) = Pkn;
    b(i) = Qkn;
end

figure; hold on;
h = gobjects(2,1);
h(1) = plot(n, a, 'DisplayName', 'Non-empty signal sifting rate');
h(2) = plot(n, b, 'DisplayName', 'Empty signal sifting rate');
hold off;
axis([n(1) nmax 0 1])
xlabel('$n$'); ylabel('Sifting rate');set(gca,'YScale','log');
title([sprintf('\\textbf{ESD module sifting rate, where $P=%g$,\\ }',P) klabel]);
legend(h,'Location','best','Interpreter','latex');
grid on;
name=sprintf('Sifting%g.eps', P);
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);

end