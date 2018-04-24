clear all;
clc;   %��������
d=xlsread('4_Normalized.xlsx');
%load Data-Ass2;
out=4;
dat=d(1:1200,1:2);
labels=d(1:1200,out);
inputNums=2; %�����ڵ�
outputNums=1; %�����ڵ�  ��������ֱ����1��ʾ
hideNums=34; %����ڵ���
maxcount=1000; %����������
samplenum=1200; %һ����������������
testnum=200;
precision=0.001; %Ԥ�辫��
alpha=0.01; %ѧϰ���趨ֵ
a=0.5; %BP�Ż��㷨��һ���趨ֵ��������ѵ���ĵ���ֵ�������޸� 
error=zeros(1,maxcount+1); %error�����ʼ����Ŀ����Ԥ�����ڴ�ռ�
errorp=zeros(1,samplenum); %ͬ��
w=rand(hideNums,outputNums); %10*3;w�����㵽������Ȩֵ
%���������
[Idx,C]=kmeans(dat,hideNums);
%X 2500*2�����ݾ��� 
%K ��ʾ��X����Ϊ���� 
%Idx 2500*1���������洢����ÿ����ľ����� 
%C 10*2�ľ��󣬴洢����K����������λ��
%����չ����
dd=zeros(1,hideNums); 
for i=1:hideNums
dmin=10000;
for j=1:hideNums 
    ddd=(C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2;
    if(ddd<dmin&&i~=j)
        dmin=ddd;
    end
end
dd(i)=dmin;
end
b=zeros(samplenum,hideNums); 
for i=1:samplenum
    for j=1:hideNums 
        b(i,j)=exp( -( (dat(i,1)-C(j,1))^2+(dat(i,2)-C(j,2))^2 )/(2*dd(j)) );%ddΪ��չ����
    end
end
count=1;
while (count<=maxcount) %��������1����1000��
c=1;
while (c<=samplenum)%����ÿ���������룬�������������һ��BPѵ����samplenumΪ2500
	double o;
	o=0.0;
	for i=1:hideNums
		o=o+b(c,i)*w(i,1);
    end
	errortmp=0.0;  
	errortmp=errortmp+(labels(c,1)-o)^2; % ��һ��ѵ�����������  
	errorp(c)=0.5*errortmp;     
	yitao=labels(c,1)-o; %��������
	for i=1:hideNums  %���ڵ�ÿ�����ص㵽������Ȩ��
		w(i,1)=w(i,1)+alpha*yitao*b(c,i);%Ȩֵ����
    end
	c=c+1; %������һ����������
end  %�ڶ���while��������ʾһ��ѵ������
%�����һ�ε��������
double tmp;
tmp=0.0;
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
%����
test=zeros(testnum,hideNums); 
for i=samplenum+1:samplenum+testnum
    for j=1:hideNums 
        test(i-samplenum,j)=exp( -( (d(i,1)-C(j,1))^2+(d(i,2)-C(j,2))^2 )/(2*dd(j)) );
    end
end
count=0;
for i=samplenum+1:samplenum+testnum
    net=0.0;
    for j=1:hideNums
        net=net+test(i-samplenum,j)*w(j,1);
    end
    if( (net>0&&d(i,out)==1) || (net<=0&&d(i,out)==-1) )
        count=count+1;
    end
end