%��Ԫ��̬W,10��Ԥ�⣬W4
clear all;
clc;   %��������
mydata=xlsread('4_ADV_m4.xlsx');
firstnum=1;    %�׸���ʼ����
d=mydata(firstnum:1300,:);
tic;
inputnum=11;    %�����ڵ� ������������� 
outputnum=1;    %�����ڵ�  ��������ֱ����1��ʾ
buchang=10;
out=inputnum+buchang; %���������
hidenum=34;           %����ڵ���
maxcount=1000;        %����������
samplenum=800;   %ѵ����
testnum=200;     %���Լ�
allnum=samplenum+testnum;
precision=0.0001; %Ԥ�辫��
alpha=0.009;       %ѧϰ���趨ֵ
beta=1.02;
a=0.5; %BP�Ż��㷨��һ���趨ֵ��������ѵ���ĵ���ֵ�������޸� 
error=zeros(1,maxcount+1); %error�����ʼ����Ŀ����Ԥ�����ڴ�ռ�
errorp=zeros(1,samplenum); %ͬ��
w=rand(hidenum,outputnum); %10*1;w�����㵽������Ȩֵ
dat=d(1:samplenum,1:inputnum);
labels=d(1:samplenum,out);
testlabels=d(samplenum+1:allnum,out);
%���������
[Idx,C]=kmeans(dat,hidenum);
tic;
%����չ����
dd=zeros(1,hidenum); 
for i=1:hidenum
    dmin=10000;
    ddd=0;
    for j=1:hidenum 
        for t=1:inputnum
            ddd=ddd+(C(i,t)-C(j,t))^2;
        end
        %�޸�ʵ��S-LMRBF,M-LMRBF,MUL-LMRBF
        if(ddd<dmin&&i~=j)
            dmin=ddd;
        end
    end
    dd(i)=dmin;
end
%bΪ���м������������������
b=zeros(allnum,hidenum); 
for i=1:allnum
    for j=1:hidenum
        dddd=0;
        for t=1:inputnum
            dddd=dddd+(d(i,t)-C(j,t))^2;
        end
        b(i,j)=exp( -( dddd )/(2*dd(j)) );
        %b(i,j)=exp( -( (d(i,1)-C(j,1))^2 + (d(i,2)-C(j,2))^2)/(2*dd(j)) );%ddΪ��չ����+(d(i,19)-C(j,19))^2+(d(i,20)-C(j,20))^2+(d(i,21)-C(j,21))^2+(d(i,22)-C(j,22))^2
    end
end
count=1;
while (count<=maxcount) %��������1����2000��
    c=1;
    while (c<=samplenum)
        %o�����ֵ
        double o;
        o=0.0;
        for i=1:hidenum
            o=o+b(c,i)*w(i,1);
        end
        %����/�޸�; 
        errortmp=0.0;  
        errortmp=errortmp+(labels(c,1)-o)^2; % ��һ��ѵ�����������  
        errorp(c)=0.5*errortmp;      
%         neww=
        J=labels(c,1)-o; %��������
        for i=1:hidenum  %���ڵ�ÿ�����ص㵽������Ȩ��
            w(i,1)=w(i,1)+alpha*J*b(c,i);%Ȩֵ����
        end 
        c=c+1; %������һ����������
    end  %�ڶ���while��������ʾһ��ѵ������
    %�����һ�ε��������
    double tmp;
    tmp=0.0; %�ִ�8 
    for i=1:samplenum
        tmp=tmp+errorp(i)*errorp(i);%������
    end
    tmp=tmp/c;
    error(count)=sqrt(tmp);%�������count�ֵ�����������,������
    if (error(count)<precision)%��һ����������
        break;
    end
    count=count+1;%ѵ��������1
end
toc;
%����
tic;
test=zeros(testnum,hidenum); 
for i=samplenum+1:allnum
    for j=1:hidenum 
        dddd=0;
        for t=1:inputnum
            dddd=dddd+(d(i,t)-C(j,t))^2;
        end
        test(i-samplenum,j)=exp( -( dddd )/(2*dd(j)) );
    end
end
count=0;
testout=zeros(testnum,1);
% errorp(1)=100;
for i=samplenum+1:allnum
    net=0.0;
    for j=1:hidenum
        net=net+test(i-samplenum,j)*w(j,1);
    end
    if( (net>0&&d(i,outputnum)==1) || (net<=0&&d(i,outputnum)==-1) )
        count=count+1;
    end
    testout(i-samplenum,1)=net;
    %����/�޸�; 
    errortmp=0.0;  
    errortmp=errortmp+(testlabels(i-samplenum,1)-net)^2; % ��һ��ѵ�����������  
    errorp(i-samplenum)=0.5*errortmp;

    if errorp(i-samplenum)>precision
        
        J=testlabels(i-samplenum,1)-net; %��������
        for k=1:hidenum  %���ڵ�ÿ�����ص㵽������Ȩ��
            w(k,1)=w(k,1)+alpha*J*b(i,k);%Ȩֵ����
        end        
    end       
end
toc;
RMSE=0;
for i=1:testnum
    RMSE=RMSE+errorp(i);
end
RMSE=sqrt(RMSE/testnum)
% ����һ��;
testlabels=d(samplenum+1:allnum)*1228.917331+217.8615552;
testout=smooth(testout*1228.917331+217.8615552,1);
figure;
plot(testout,'-');
hold on;
plot(testlabels,'r:');
axis([1,testnum,0,1500]);
testlabels=testlabels';