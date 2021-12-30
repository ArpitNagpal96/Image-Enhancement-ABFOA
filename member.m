function [UX,Fh]=member(xmax,xavg,p)
%spatial to fuzzy convertion using gaussian function
%created by Krishna on wednesday 20th Dec 2006
%use xmax,xavg and p as inputs
%formatto use [UX,Fh]=member(xmax,xavg,p)
s1=0;s2=0;x=0;
s10=(((xmax-x).^4).*p(x+1));
s20=(((xmax-x).^2).*p(x+1));
for x=1:1:255
    s1=s1+(((xmax-x).^4).*p(x+1));
    s2=s2+(((xmax-x).^2).*p(x+1));
end
s1=s1+s10;
s2=s2+s20;
Fh=sqrt(s1/(2*s2));
%UX(1)=exp(((xmax-xavg)^2)/(2*Fh^2));
% Fh=115.66;
for x=1:1:256
    UX(x)=exp((-(xmax-(xavg-(x-1)))^2)/(2*Fh^2));
end