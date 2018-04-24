%多元动态W,10步预测，W4
clear all;
clc;   %清除命令窗口
mydata=xlsread('4_ADV_m4.xlsx');
firstnum=1;    %首个开始样本
d=mydata(firstnum:1300,:);
tic;
inputnum=11;    %输入层节点 输入的数据列数 
outputnum=1;    %输出层节点  许多情况下直接用1表示
buchang=10;
out=inputnum+buchang; %输出的列数
hidenum=34;           %隐层节点数
maxcount=1000;        %最大迭代次数
samplenum=800;   %训练集
testnum=200;     %测试集
allnum=samplenum+testnum;
precision=0.0001; %预设精度
alpha=0.009;       %学习率设定值
beta=1.02;
a=0.5; %BP优化算法的一个设定值，对上组训练的调整值按比例修改 
error=zeros(1,maxcount+1); %error数组初始化；目的是预分配内存空间
errorp=zeros(1,samplenum); %同上
w=rand(hidenum,outputnum); %10*1;w表隐层到输出层的权值
dat=d(1:samplenum,1:inputnum);
labels=d(1:samplenum,out);
testlabels=d(samplenum+1:allnum,out);
%求聚类中心
[Idx,C]=kmeans(dat,hidenum);
tic;
%求扩展常数
dd=zeros(1,hidenum); 
for i=1:hidenum
    dmin=10000;
    ddd=0;
    for j=1:hidenum 
        for t=1:inputnum
            ddd=ddd+(C(i,t)-C(j,t))^2;
        end
        %修改实现S-LMRBF,M-LMRBF,MUL-LMRBF
        if(ddd<dmin&&i~=j)
            dmin=ddd;
        end
    end
    dd(i)=dmin;
end
%b为进行计算后隐含层的输入矩阵
b=zeros(allnum,hidenum); 
for i=1:allnum
    for j=1:hidenum
        dddd=0;
        for t=1:inputnum
            dddd=dddd+(d(i,t)-C(j,t))^2;
        end
        b(i,j)=exp( -( dddd )/(2*dd(j)) );
        %b(i,j)=exp( -( (d(i,1)-C(j,1))^2 + (d(i,2)-C(j,2))^2)/(2*dd(j)) );%dd为扩展常数+(d(i,19)-C(j,19))^2+(d(i,20)-C(j,20))^2+(d(i,21)-C(j,21))^2+(d(i,22)-C(j,22))^2
    end
end
count=1;
while (count<=maxcount) %结束条件1迭代2000次
    c=1;
    while (c<=samplenum)
        %o输出的值
        double o;
        o=0.0;
        for i=1:hidenum
            o=o+b(c,i)*w(i,1);
        end
        %反馈/修改; 
        errortmp=0.0;  
        errortmp=errortmp+(labels(c,1)-o)^2; % 第一组训练后的误差计算  
        errorp(c)=0.5*errortmp;      
%         neww=
        J=labels(c,1)-o; %输出层误差
        for i=1:hidenum  %调节到每个隐藏点到输出点的权重
            w(i,1)=w(i,1)+alpha*J*b(c,i);%权值调整
        end 
        c=c+1; %输入下一个样本数据
    end  %第二个while结束；表示一次训练结束
    %求最后一次迭代的误差
    double tmp;
    tmp=0.0; %字串8 
    for i=1:samplenum
        tmp=tmp+errorp(i)*errorp(i);%误差求和
    end
    tmp=tmp/c;
    error(count)=sqrt(tmp);%求迭代第count轮的误差求均方根,即精度
    if (error(count)<precision)%另一个结束条件
        break;
    end
    count=count+1;%训练次数加1
end
toc;
%测试
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
    %反馈/修改; 
    errortmp=0.0;  
    errortmp=errortmp+(testlabels(i-samplenum,1)-net)^2; % 第一组训练后的误差计算  
    errorp(i-samplenum)=0.5*errortmp;

    if errorp(i-samplenum)>precision
        
        J=testlabels(i-samplenum,1)-net; %输出层误差
        for k=1:hidenum  %调节到每个隐藏点到输出点的权重
            w(k,1)=w(k,1)+alpha*J*b(i,k);%权值调整
        end        
    end       
end
toc;
RMSE=0;
for i=1:testnum
    RMSE=RMSE+errorp(i);
end
RMSE=sqrt(RMSE/testnum)
% 反归一化;
testlabels=d(samplenum+1:allnum)*1228.917331+217.8615552;
testout=smooth(testout*1228.917331+217.8615552,1);
figure;
plot(testout,'-');
hold on;
plot(testlabels,'r:');
axis([1,testnum,0,1500]);
testlabels=testlabels';