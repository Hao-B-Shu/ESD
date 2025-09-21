function Plot3D(varargin)

Para=inputParser;
addOptional(Para,'nmax',9);
addOptional(Para,'t',10^(-7));
addOptional(Para,'saveDir','');
parse(Para,varargin{:});

nmax=Para.Results.nmax;
t=Para.Results.t;
saveDir=Para.Results.saveDir;

set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesLineWidth',1.1);

set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultAxesTitleFontSizeMultiplier', 1.05);

set(groot, 'defaultAxesTitleFontWeight','bold');
set(groot, 'defaultAxesFontWeight', 'bold');

set(groot, 'defaultTextInterpreter','latex');

[X,Y] = meshgrid(0:nmax,0:nmax);
SESD = NaN(size(X));
NESR = NaN(size(X));
QBER = NaN(size(X));

for n = 0:nmax
    for k = 0:n
        [SESD(k+1,n+1),NESR(k+1,n+1),QBER(k+1,n+1)] = SESD_NESR_QBER('t',t,'n',n,'k',k); 
    end
end

figure;
h1=imagesc(0:nmax, 0:nmax, log10(SESD)); 
colormap(parula(256));
colorbar;
xlabel('$n$'); ylabel('$k$');
title(sprintf('\\textbf{SESD with respect to $n,k$, where $t=10^{%d}$}',log10(t)));
axis xy;
set(h1,'AlphaData',~isnan(SESD));
cb = colorbar;
cb.Ticks = -24:4:0; 
cb.TickLabels = arrayfun(@(x) sprintf('10^{%d}', x), cb.Ticks, 'UniformOutput', false);
name=sprintf('SESD(t=10^%d).eps', log10(t));
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);

figure;
h2=imagesc(0:nmax, 0:nmax, log10(NESR));
colormap(parula(256));
colorbar;
xlabel('$n$'); ylabel('$k$');
title(sprintf('\\textbf{NESR with respect to $n,k$, where $t=10^{%d}$}',log10(t)));
axis xy;
set(h2,'AlphaData',~isnan(SESD));
cb = colorbar;
cb.Ticks = -8:2:0;
cb.TickLabels = arrayfun(@(x) sprintf('10^{%d}', x), cb.Ticks, 'UniformOutput', false);
name=sprintf('NESR(t=10^%d).eps', log10(t));
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);

figure;
scatter3(X, Y, QBER, 'b','filled');
xlabel('$n$'); ylabel('$k$'); zlabel('QBER');
title(sprintf('\\textbf{Fundamental QBER with respect to $n,k$, where $t=10^{%d}$}',log10(t)));
grid on;
view([1 1 0.5]);
name=sprintf('QBER(t=10^%d).eps', log10(t));
filepath = fullfile(saveDir, name);
print(gcf, '-depsc', filepath);