function [SESD,NESR,QBER,Pkn,Qkn]=SESD_NESR_QBER(varargin)%eta,d,ep,ec,u,n,k,P,t,e

Para=inputParser;
addOptional(Para,'eta',0.78);
addOptional(Para,'d',10^(-7));
addOptional(Para,'Q',0.002);
addOptional(Para,'ec',0);
addOptional(Para,'n',3);
addOptional(Para,'k',1);
addOptional(Para,'P',0.99);
addOptional(Para,'p1',0.99);
addOptional(Para,'t',10^(-5));
addOptional(Para,'dig',32);
parse(Para,varargin{:});

eta=Para.Results.eta;
d=Para.Results.d;
Q=Para.Results.Q;
ec=Para.Results.ec;
P=Para.Results.P;
p1=Para.Results.p1;
n=Para.Results.n;
k=Para.Results.k;
t=Para.Results.t;
dig=Para.Results.dig;

digits(dig);
t=vpa(t);
d=vpa(d);
P=vpa(P);
p1=vpa(p1);
Q=vpa(Q);
ec=vpa(ec);
eta=vpa(eta);
n=vpa(n);
k=vpa(k);

Ps=P*(eta+(1-eta)*d)+(1-P)*d;
Qs=Q*(eta+(1-eta)*d)+(1-Q)*d;

if n==0
    Pknmain=1;
else
    Pknmain = vpa(0);
    for m = k:n
        Pknmain = Pknmain + nchoosek(n,m)*(Ps^m)*(1-Ps)^(n-m);
    end
end

if n==0
    Qkn=1;
else
    Qkn = vpa(0);
    for m = k:n
        Qkn = Qkn + nchoosek(n,m)*(Qs^m)*(1-Qs)^(n-m);
    end
end

if n==0
    Pkn=1;
else
    Pkn = p1^(n-1)*Pknmain;
    for i = 1:(n-1)
            inner_sum = 0;
            for j1 = 0:i
                for j2 = 0:(n-i)
                    if (j1 + j2) >= k
                        term = nchoosek(i, j1)*Ps^j1*(1-Ps)^(i-j1)*nchoosek(n-i, j2)*Qs^j2*(1-Qs)^(n-i-j2);
                        inner_sum = inner_sum + term;
                    end
                end
            end
            Pkn = Pkn + p1^(i-1)*(1-p1)*inner_sum;
    end
end

SESD=t*Pkn+(1-t)*Qkn;
NESR=(t*p1^(n)*Pknmain)./SESD;

ct=(1-ec)*(eta+(1-eta)*d)*(1-d)+ec*(1-eta)*d*(1-d);
et=ec*(eta+(1-eta)*d)*(1-d)+(1-ec)*(1-eta)*d*(1-d);
cl=d*(1-d);
el=d*(1-d);
QBER=(NESR*et+(1-NESR)*el)./(NESR*(et+ct)+(1-NESR)*(el+cl));

end
