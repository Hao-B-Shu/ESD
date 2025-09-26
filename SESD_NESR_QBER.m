function [SESD,NESR,QBER,Pkn,Qkn]=SESD_NESR_QBER(varargin)%eta,d,ep,ec,u,n,k,P,t,e

Para=inputParser;
addOptional(Para,'eta',0.78);
addOptional(Para,'d',10^(-7));
addOptional(Para,'ep',0.002);
addOptional(Para,'ec',0);
addOptional(Para,'y',1-exp(-5));
addOptional(Para,'n',3);
addOptional(Para,'k',1);
addOptional(Para,'P',0.99);
addOptional(Para,'t',10^(-5));
addOptional(Para,'dig',32);
parse(Para,varargin{:});

eta=Para.Results.eta;
d=Para.Results.d;
ep=Para.Results.ep;
ec=Para.Results.ec;
y=Para.Results.y;
n=Para.Results.n;
k=Para.Results.k;
P=Para.Results.P;
t=Para.Results.t;
dig=Para.Results.dig;

digits(dig);
t=vpa(t);
d=vpa(d);
P=vpa(P);
ep=vpa(ep);
ec=vpa(ec);
eta=vpa(eta);
n=vpa(n);
k=vpa(k);
y=vpa(y);

Ps=(1-y)*(P*(eta+(1-eta)*d)+(1-P)*d)+y*d;
Qs=(1-y)*(ep*(eta+(1-eta)*d)+(1-ep)*d)+y*d;

Pkn = vpa(0);
for m = k:n
    Pkn = Pkn + nchoosek(n,m)*(Ps^m)*(1-Ps)^(n-m);
end
%Pkn = 1 - binocdf(k-1, n, Ps);

Qkn = vpa(0);
for m = k:n
    Qkn = Qkn + nchoosek(n,m)*(Qs^m)*(1-Qs)^(n-m);
end
%Qkn = 1 - binocdf(k-1, n, Qs);


NESR=(t*Pkn)./(t*Pkn+(1-t)*Qkn);

ct=(1-ec)*(eta+(1-eta)*d)*(1-d)+ec*(1-eta)*d*(1-d);
et=ec*(eta+(1-eta)*d)*(1-d)+(1-ec)*(1-eta)*d*(1-d);
cl=d*(1-d);
el=d*(1-d);
QBER=(NESR*et+(1-NESR)*el)./(NESR*(et+ct)+(1-NESR)*(el+cl));

SESD=t*Pkn+(1-t)*Qkn;

end
