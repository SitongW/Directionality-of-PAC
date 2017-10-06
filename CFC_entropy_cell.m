function Y=CFC_entropy_cell(C,range1,range2,width,srate,fil_mode,bin,cross)
% 在小窗口内，用CFC-entropy方法求PAC
% 输入cell，每个元素是一个单独的数据，第一列是时间，第二列是第一导，第三列是第二导
% range1为theta波滤波范围，如range1=[3,4;4,5;5,6;6,7;7,8];
% range2为gamma波滤波范围，如range2=[30,31;31,32;...;99,100];
% 窗口长度width，50% overlap；srate为采样频率
% fil_mode为滤波方式：eegfilt和wavelet两个选择
% bin为x每个相位周期分的区间数，bin通常取18，即将360度的周期分成18个20度的区间
% cross：‘aa’指示做chan1和chan1之间的MI；‘ab’指示做chan1和chan2之间的MI
%         同理’ba‘和’bb‘

% 输出：每个样本的结果依然存成cell，2*样本数个元素
% Row1：每个元素为entropy
% 第1列为窗口初始时间点，第2列为每个窗口的平均entropy值
% Row2：每个元素为gamma_amp在theta每个角度格子内的pdf
% 为四维维矩阵，（j,p,q,:）为第j个窗口theta第i个频段内gamma第j个频段内，在bin个区间上的平均的分布概率



num=length(C);
Y=cell(2,num);
n1=size(range1,1);
n2=size(range2,1);
width_wav=7;
for i=1:num
    time1=C{i}(:,1);
    if strcmp(cross,'aa')
        X1=C{i}(:,2);
        X2=C{i}(:,2);
    end
    if strcmp(cross,'ab')
        X1=C{i}(:,2);
        X2=C{i}(:,3);
    end
    if strcmp(cross,'ba')
        X1=C{i}(:,3);
        X2=C{i}(:,2);
    end
    if strcmp(cross,'bb')
        X1=C{i}(:,3);
        X2=C{i}(:,3);
    end
    X1=X1-mean(X1);
    X2=X2-mean(X2);
    len=length(X1);
    winnum=floor(len/(width/2)-1);
    for p=1:n1   % theta
        for q=1:n2   % gamma
            if strcmp(fil_mode,'eegfilt')
                x1=eegfilt(X1',srate,range1(p,1),range1(p,2))';
                [x1_ph,x1_ang]=extract_phase_hilbert(x1);
                x2=eegfilt(X2',srate,range2(q,1),range2(q,2))';
                x2_amp=extract_amp_hilbert(x2);
            else if strcmp(fil_mode,'wavelet')
                x1_ang=phasevec((range1(p,1)+range1(p,2))/2,X1,srate,width_wav);
                x2_amp=ampvec((range2(q,1)+range2(q,2))/2,X2,srate,width_wav);
                end
            end
%             figure;
            for j=1:winnum
                time0=C{i}((j-1)*(width/2)+1,1);
                [pdf,ent]=CFC_entropy(x1_ang((j-1)*(width/2)+1:(j+1)*(width/2),1),x2_amp((j-1)*(width/2)+1:(j+1)*(width/2),1),bin);
                Pdf(j,:)=pdf;
                Ent(j)=ent;
%                 subplot(8,10,j); 
%                 plot(pdf)   % plot
            end
            Y{1,i}(q,p)=mean(Ent);
            Y{2,i}(q,p,:)=mean(Pdf);
        end
    end
end
