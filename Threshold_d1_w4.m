%QoS��ʷ������������
clear;
clc;
mydata=xlsread('4.xlsx');
sx=1; %change attribute
N=2000;
yy=mydata(:,sx);
% load RMBdata1c6;%һ��ȥ��������
adv=zeros(2,1);
sum=zeros(2,1);
for i=1:2
    temp=0;
    for j=1:N
        if mydata(j,i)>0
            sum(i,1)=sum(i,1)+mydata(j,i);
            temp=temp+1;
        end
        if j==N
            adv(i,1)=sum(i,1)/temp;
        end
    end
end
for j=1:N
        if (mydata(j,1)<0 || mydata(j,1)>4000)
            mydata(j,1)=(mydata(j-1,1)+mydata(j+1,1))/2;
        end
end

for j=1:N
        if (mydata(j,2)<0 || mydata(j,2)>30000)
            mydata(j,2)=(mydata(j-1,2)+mydata(j+1,2))/2;
        end
end
leleccum=mydata(:,sx);
indx = 1:N;
x = leleccum(indx);
%���������ź�
init = 2055615866;
randn('seed',init);
nx = x + 18*randn(size(x));
%ʹ��С������'db5'���źŽ���3��ֽ�
[c,l] = wavedec(nx,3,'db5');
%���ó߶�����
n = [1,2,3];
%������ֵ����
p = [100,90,80];
%�Ը�Ƶϵ��������ֵ����
nc = wthcoef('d',c,l,n,p);
%���������С���ֽ�ṹ�����ع�
rx = waverec(nc,l,'db5');
for i=1:N
    if (rx(i)<=0 || isnan(rx(i)))
        rx(i)=leleccum(i);
    end
end
subplot(221);
plot(yy);
title('original data');
subplot(222);
plot(x);
title('Processed data');
subplot(223);
plot(nx);
title('Noisy data');
subplot(224);
plot(rx);
title('De-noised data');
% RMBdata1c7=rx;
dd1=rx;
threshold(:,sx)=rx;
