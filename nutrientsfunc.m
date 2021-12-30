% Function to be optimized:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J]=nutrientsfunc(theta,flag,iteration)

if flag==1  % Test to see if main program indicated nutrients
	J=0;
	return
end


% An example function to optimize:

%	J=...
%		+5*exp(-0.1*((theta(1,1)-15)^2+(theta(2,1)-20)^2))...
%		-2*exp(-0.08*((theta(1,1)-20)^2+(theta(2,1)-15)^2))...
%		+3*exp(-0.08*((theta(1,1)-25)^2+(theta(2,1)-10)^2))...
%		+2*exp(-0.1*((theta(1,1)-10)^2+(theta(2,1)-10)^2))...
%		-2*exp(-0.5*((theta(1,1)-5)^2+(theta(2,1)-10)^2))...
%		-4*exp(-0.1*((theta(1,1)-15)^2+(theta(2,1)-5)^2))...
%	    -2*exp(-0.5*((theta(1,1)-8)^2+(theta(2,1)-25)^2))...
%		-2*exp(-0.5*((theta(1,1)-21)^2+(theta(2,1)-25)^2))...
%		+2*exp(-0.5*((theta(1,1)-25)^2+(theta(2,1)-16)^2))...
%		+2*exp(-0.5*((theta(1,1)-5)^2+(theta(2,1)-14)^2));
%--------------------------------------------------------------------------
%------------------------Fuzzy contast Calculation-------------------------
%--------------------------------------------------------------------------

t=5+2*sin(theta(1,1));
Uc=0.5+0.1*(sin(theta(2,1)));
Fh=theta(3,1);
g=2+(sin(theta(4,1)))^2;
%g=2;
%Uc=0.5;
L=256;
if iteration==1;
    [a,P,xmax,xavg,m,n]=mainprogram();
    savefile = 'test.mat';
    save(savefile,'a','P','xmax','xavg','m','n');
else
load test.mat;
end
for i=1:1:256;
    if i<a;
        UX2(i)=0;
    else
        UX2(i)=(i-a)/(L-a);
    end
end
UXx2=(UX2).^g;
[UX1,Fh1]=member(xmax,xavg,P);
UXx1=1./(1+exp(-t.*(UX1-Uc)));

Cf1=0;
Cf01=0;
Caf01=0;
Caf1=0;
Uc=0;
for x=0:1:L-1;
    Cf1=(Cf1+((UXx1(x+1)-Uc).^2).*P(x+1));
    Cf01=Cf01+(((UX1(x+1)-Uc).^2).*P(x+1));
    Caf01=Caf01+((UX1(x+1)-Uc).*P(x+1));
    Caf1= Caf1+((UXx1(x+1)-Uc).*P(x+1));
end
Cf1=Cf1/L;
Cf01=Cf01/L;
Caf01=Caf01/L;
Caf1=Caf1/L;
pu=0;
for x=1:1:L-1;
    pu=pu+P(x);
end
if pu==0
    Qf01=0;
    Qf1=0;
    vf1=0;
else
    Qf01=(abs(Caf01))/Cf01;
    Qf1=(abs(Caf1))/Cf1;
    vf1=Qf1/Qf01;
end    

Cf2=0;
Cf02=0;
Caf02=0;
Caf2=0;
Uc1=1;
for x=a:1:L-1;
    Cf2=Cf2+(((UXx2(x+1)-Uc1).^2).*P(x+1));
    Cf02=Cf02+(((UX2(x+1)-Uc1).^2).*P(x+1));
    Caf02=Caf02+((UX2(x+1)-Uc1).*P(x+1));
    Caf2=Caf2+((UXx2(x+1)-Uc1).*P(x+1));
end
Cf2=Cf2/L;
Cf02=Cf02/L;
Caf02=Caf02/L;
Caf2=Caf2/L;
po=m*n-pu;
if po==0;
    Qf02=0;
    Qf2=0;
    vf2=0;
else
    Qf2=(abs(Caf2))/Cf2;
    Qf02=(abs(Caf02))/Cf02;
    vf2=Qf02/Qf2;
end
vf=(vf1*a+vf2*(L-a))/L;

%---------------------------------------------------------------------------
%-------------------------------Fuzzy Entropy-------------------------------
%---------------------------------------------------------------------------
E1=0;E2=0;E=0;
for i=0:1:L-1;
    if i<a;
        %UX=UX1;
       % UXx=UXx1;
        E1=E1+(-1*(UXx1(i+1).*(log(UXx1(i+1)+.00000000001))+(1-UXx1(i+1)).*(log(1-UXx1(i+1)+.00000000001))));
   else
     %UX(i+1)=UX2(i+1);
       %UXx(i+1)=UXx2(i+1);
        E1=E1+(-1*(UXx2(i+1).*(log(UXx2(i+1)+.00000000001))+(1-UXx2(i+1)).*(log(1-UXx2(i+1)+.00000000001))));
    end
end
E=(E1+E2)/(L*log(2));
%E=(-sum(UXx.*(log(UXx+.00000000001))+(1-UXx).*(log(1-UXx+.00000000001))))
%(L*log(2));
J=E+(abs(1.5-vf));
E
vf1
vf2
vf
array=zeros(1,8);
array(1)=t;
array(2)=Uc;
array(3)=Fh;
array(4)=g;
array(5)=E;
array(6)=vf1;
array(7)=vf2;
array(8)=vf;
array