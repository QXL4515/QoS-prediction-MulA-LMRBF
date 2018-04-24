clear all;
clc;clear;
mydata=xlsread('4_Threshold.xlsx');
data(:,1)=mydata(:,1);
data(:,2)=mydata(:,2);
data(:,3)=mydata(:,3);
data=data';%60*4
% 数据归一化处理4*60
for j=1:3
    a(j)=max(data(j,:))-min(data(j,:));
    b(j)=min(data(j,:));
end
for i=1:3
    data(i,:)=(data(i,:)-min(data(i,:)))/(max(data(i,:))-min(data(i,:)));
end
N=2000;
jg=20;
data=data';%60*4
y1=data(1:jg:N,1);
y2=data(1:jg:N,2);
figure;
x=1:jg:N;
plot(x,y1,'-');
hold on;
plot(x,y2,'-r');
legend('Response time(ms)','Throughput(bps)');
% title('模型预测');
 xlabel('Sample points');
 ylabel('QoS value');
% axis([1 100 200 800]);
 set(gca,'XTick',1:200:N);