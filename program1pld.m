%--------------------------------------
%--------------new2.m------------------
%--------------------------------------


clc;
clear all;
close all;
a=177;
%params=[5.3303 0.5165 80.8551 2.2439]; %normal    
params=[6.6633 0.7832 81.9153 2.3032]; %adaptive
Uc=params(2);
t=params(1);
L=256;
g=params(4);
e=.01;
f=100;
f1=100;
x=1:1:256;
RGB=imread('C:\Users\Arpit\Desktop\RP Major\Codes\image12.png'); % Give the correct pathof the required image
% RGB=imread('flower2.jpg');
HSV=rgb2hsv(RGB);
H=HSV;
V=HSV(:,:,3);
X=0:1:255;
V=im2uint8(V);
P=imhist(V);
P=P';
value=sum(X.*P)/(sum(P));
a=round(L-value);
a=a+50
if (a>=L)
    a=L-1;
end
% a=180;
% Uc=((a)/2)/L;
xmax=double(max(max(V)));
xavg=double(mean(mean(V)));
for i=1:1:256;
    if i<a;
        UX(i)=0;
    else
        UX(i)=(i-a)/(L-a);
    end
end
UXx=.95.*(UX+.0001).^(g);
for i=1:1:256;
    if (UXx(i)>0);
        xx(i)=a+UXx(i).*(L-a);
    else
        xx(i)=i;
    end
end
[UX1,Fh]=member(xmax,xavg,P);
Fh=params(3);
UXx1=1./(1+exp(-t.*(UX1-Uc)));
xx1=xavg-xmax+sqrt(-2.*log(UXx1).*(Fh^2));
xx1=xx1-min(xx1);
xx=(xx./max(xx));
xx1=(xx1./max(xx1));
while ((xx1(a)-xx(a))>e)
    f=f-2;
    f1=f1+.1;
    xx1=(f.*xx1)./100;
    xx=(f1.*xx)./100;
end  
f1
f
for k=1:1:L
    if (k<=a);
        new(k)=xx1(k);
    else
        new(k)=xx(k);
    end
end           
[m,n]=size(V);
for i=1:1:m;
    for j=1:1:n;
        k=V(i,j);
        Vv(i,j)=new(k+1);
    end
end
s=HSV(:,:,2);
ss=power(s,2/3);
Vv=Vv./(f1/100);
HSV(:,:,3)=Vv;
I=hsv2rgb(HSV);
% HSV(:,:,2)=ss;
I1=hsv2rgb(HSV);
 figure,
 imhist(Vv)
 imshow(I1);
 title('modified with proposed technique');
 V=mat2gray(double(V));
 figure,imshow(imread('C:\Users\Arpit\Desktop\RP Major\Codes\image12.png'));
 title('original');
 imwrite(I1,'C:\Users\Arpit\Desktop\RP Major\Codes\image12_adaptive_bfoa_2.png','png');
%imwrite(RGB,'D:\Arpit (I)\codes\images\new\Orignal_Doctor.jpg','jpg');

%histogram;
%--------------------------------------------------------------------------
%------------------------Fuzzy contast Calculation-------------------------
%--------------------------------------------------------------------------
Uc=((a+L)/2)/L;
Cf2=0;
Cf02=0;
Caf02=0;
Caf2=0;
for x=a:1:L-1;
    Cf2=(Cf2+((UXx(x+1)-Uc).^2).*P(x+1));
    Cf02=Cf02+(((UX(x+1)-Uc).^2).*P(x+1));
    Caf02=Caf02+((UX(x+1)-Uc).*P(x+1));
    Caf2= Caf2+((UXx(x+1)-Uc).*P(x+1));
end
Cf2=Cf2/L
Cf02=Cf02/L
Caf02=Caf02/L
Caf2=Caf2/L
Qf01=(abs(Caf02))/Cf02
Qf1=(abs(Caf2))/Cf2
Vf1=Qf1/Qf01