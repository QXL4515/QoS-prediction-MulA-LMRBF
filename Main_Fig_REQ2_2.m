clear;
clc;

mydata=xlsread('Req1_2.xlsx');

data(:,1)=mydata(:,1);
data(:,2)=mydata(:,3);
data(:,3)=mydata(:,5);
data(:,4)=mydata(:,7);
data(:,5)=mydata(:,10);

N=100;
 jg=5;
y1=data(1:jg:N,1);
y2=data(1:jg:N,2);  
y3=data(1:jg:N,3); 
y4=data(1:jg:N,4);
y5=data(1:jg:N,5);

figure;
 x=1:jg:N;
% y1=d1(0:10:100,:);
% y2=d2(0:10:100,:);
% y3=d3(0:10:100,:);
% y4=d4(0:10:100,:);
plot(x,y1,'-');
hold on;
plot(x,y2,'-r');
hold on;
plot(x,y3,'-c');
hold on;
plot(x,y4,'-y');
hold on;
plot(x,y5,'-b');

legend('Actual','S-LMRBF','M-LMRBF','Mul-LMRBF','MulA-LMRBF');
% title('Ä£ÐÍÔ¤²â');
 xlabel('Sample points');
 ylabel('Response time(ms)');
% axis([1 100 200 800]);
 set(gca,'XTick',0:10:N);
%  set(gca,'YTick');
 x=x';