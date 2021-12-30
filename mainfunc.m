function [a,P,xmax,xavg,m,n]=mainprogram();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function for the calculation of various parameters required by the
% optimization function.
L=256;
    RGB=imread('C:\Users\Rishi\Desktop\RP Major\Codes\image12.png'); % Give the correct pathof the required image
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
    xmax=double(max(max(V)));
    xavg=double(mean(mean(V)));
    [m,n]=size(V);