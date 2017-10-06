function [ S ] = simulation( TimeLag )
% Generate numeriacla simulated signals
%------------- alpha rhythm---------------------
S_alpha=[];
for j=1:5000
     T=round(normrnd(0.1,0.1)*1000)/1000;
     if T<0 ;
         T=0.0010;
     end
     f_alpha=normrnd(10,3);
     if f_alpha<0
         f_alpha=0.1;
     end
     A=normrnd(10,1);
     if A<0
         A=0.1;
     end
     t=[0:0.001:T];
     S_alpha=[S_alpha,A.*(1.+sin(2.*pi.*f_alpha.*t))];
end

%--------- gamma oscillation without TimeLag--------------
a=10;c=6;
t=[1:length(S_alpha)]./1000;
f_gamma=70;
S_gamma=(1-1./(1+exp(-a.*(S_alpha-c)))).*(sin(2.*pi.*f_gamma.*(t))+1);

%---------Introduce TimeLag to gamma oscillation--------------
n=round((TimeLag/0.001));
if n==0
    S_gamma_Timelag=S_gamma;
    S_alpha_Timelag=S_alpha;
elseif n>0
    S_gamma_Timelag=S_gamma((1+n):end);
    S_alpha_Timelag=S_alpha(1:(length(S_alpha)-n));
elseif n<0
    S_gamma_Timelag=S_gamma(1:(length(S_alpha)+n));
    S_alpha_Timelag=S_alpha(1-n:end);
end

%------Get the signals by summing alpha and gamma oscillations up--------
S=S_alpha_Timelag+S_gamma_Timelag;

%--------Using FFT(Fast Fourier transform) to examinate the construction, if you want---------------
% fs=1000; N=1024;    
% y=fft(S_gamma_TimeLag,N); 
%%% Here, you can input rhythms e.g. S_gamma_TimeLag,S_gamma,S_alpha and S_alpha_TimeLag.
% mag=abs(y);
% f_alpha=(0:N-1)*fs/N;
% x=f_alpha(1:N/2);
% y=mag(1:N/2)*2/N;
% plot(x(2:101),y(2:101));

end

    
