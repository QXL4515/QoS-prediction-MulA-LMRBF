%平均位移法，相空间重狗的延迟时间和嵌入维数
clear all;
clc;clear;
mydata=xlsread('4_Normalized.xlsx');
data=mydata(:,1);
N=2000;
%初始化参数值
s1=0;s2=0;s3=0;
m=4; %嵌入维数
% tao=1;
out=zeros(200,1);
for tao=1:200
    s1=0;
    for t=1:N
        s1=s1+s2;
        s2=0;
        s3=0;
        for i=1:m-1
            s2=s2+s3;
            if(t>i*tao)
                s3=(data(t-i*tao)-data(t))^2;        
            end  
        end
        s2=sqrt(s2);
    end
    out(tao)=s1/N;
end
out;
p=-1;
for i=1:199
    if out(i)>out(i+1)
        p=i;
        break;
    end
end