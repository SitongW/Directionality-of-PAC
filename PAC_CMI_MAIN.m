function Y=PAC_CMI_MAIN(C,range,width,srate,b)

% Input: 
%   -----------C, a cell type dataset, each elements of cell should be a matrix.
%   For example, C{1} is a matrix containing 1254 rows and 3 columns. The 
%   first column is time series and the second column is the signals channel-1, and
%   the third column is the signal channel-2.
%   -----------range, n*2 matrix with n rows and 2 columns. 
%   Each row has two values as thresholds like [low,high], which are the ranges of filter.
%   -----------width, is the time windows length, defaulted as 10000 point(i.e. 10 seconds if the srate is 1000) with 50% overlap
%   -----------b, is the type of filter. 
%   The default value of b is 0, which means the "eegfilt" is used here.
% Output:
%       row1:d value, which imply the direction of two signal channels. For example, d>0 means the information was transmit from Channel-1 to Channel-2 and vice versa.
%       row2£ºc2 value
%       row3£ºc1 value

if nargin<5
    b=0;
end

num=length(C);
Y=cell(3,num);
p=size(range,1);

for i=1:num
    time1=C{i}(:,1);
    X1=C{i}(:,2);
    X2=C{i}(:,3);
    len=length(X1);
    
    for j=1:p
        r=range(j,:);
        if b==0
            x1=eegfilt(X1',srate,r(1),r(2))';
            x2=eegfilt(X2',srate,r(1),r(2))';
        else
            x1=filter(b(j,:),1,X1);
            x2=filter(b(j,:),1,X2);
        end
        winnum=floor(len/(width/2)-1);
        for k=1:winnum
            [D,I12,I21]=PAC_CMI_two_signals(x1((k-1)*(width/2)+1:(k+1)*(width/2),1),x2((k-1)*(width/2)+1:(k+1)*(width/2),1),r);
            if j==1
                Y{1,i}(k,1)=time1((k-1)*(width/2)+1,1);
                Y{2,i}(k,1)=time1((k-1)*(width/2)+1,1);
                Y{3,i}(k,1)=time1((k-1)*(width/2)+1,1);
            end
            Y{1,i}(k,j+1)=D;
            Y{2,i}(k,j+1)=I12;
            Y{3,i}(k,j+1)=I21;
        end
    end
end