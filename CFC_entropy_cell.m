function Y=CFC_entropy_cell(C,range1,range2,width,srate,fil_mode,bin,cross)
% ��С�����ڣ���CFC-entropy������PAC
% ����cell��ÿ��Ԫ����һ�����������ݣ���һ����ʱ�䣬�ڶ����ǵ�һ�����������ǵڶ���
% range1Ϊtheta���˲���Χ����range1=[3,4;4,5;5,6;6,7;7,8];
% range2Ϊgamma���˲���Χ����range2=[30,31;31,32;...;99,100];
% ���ڳ���width��50% overlap��srateΪ����Ƶ��
% fil_modeΪ�˲���ʽ��eegfilt��wavelet����ѡ��
% binΪxÿ����λ���ڷֵ���������binͨ��ȡ18������360�ȵ����ڷֳ�18��20�ȵ�����
% cross����aa��ָʾ��chan1��chan1֮���MI����ab��ָʾ��chan1��chan2֮���MI
%         ͬ��ba���͡�bb��

% �����ÿ�������Ľ����Ȼ���cell��2*��������Ԫ��
% Row1��ÿ��Ԫ��Ϊentropy
% ��1��Ϊ���ڳ�ʼʱ��㣬��2��Ϊÿ�����ڵ�ƽ��entropyֵ
% Row2��ÿ��Ԫ��Ϊgamma_amp��thetaÿ���Ƕȸ����ڵ�pdf
% Ϊ��άά���󣬣�j,p,q,:��Ϊ��j������theta��i��Ƶ����gamma��j��Ƶ���ڣ���bin�������ϵ�ƽ���ķֲ�����



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
%                 plot(pdf)   %��ͼ
            end
            Y{1,i}(q,p)=mean(Ent);
            Y{2,i}(q,p,:)=mean(Pdf);
        end
    end
end