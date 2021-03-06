clear;
clc;
load RMBdata3;
Data=RMBdata3(:,1);
SourceData=Data(1:1980,1); %前250个训练集
step=100;                  %后50个测试
TempData=SourceData;
TempData=detrend(TempData);%去趋势线
TrendData=SourceData-TempData;%趋势函数
%--------差分，平稳化时间序列---------
H=adftest(TempData);
difftime=0;
SaveDiffData=[];
while ~H
SaveDiffData=[SaveDiffData,TempData(1,1)];
TempData=diff(TempData);%差分，平稳化时间序列
difftime=difftime+1;%差分次数
H=adftest(TempData);%adf检验，判断时间序列是否平稳化
end
%---------模型定阶或识别--------------
u = iddata(TempData);
test = [];
for p = 1:5                       %自回归对应PACF,给定滞后长度上限p和q，一般取为T/10、ln(T)或T^(1/2),这里取T/10=12
for q = 1:5                    %移动平均对应ACF
m = armax(u,[p q]);        
AIC = aic(m);              %armax(p,q),计算AIC
test = [test;p q AIC];
end
end
for k = 1:size(test,1)
if test(k,3) == min(test(:,3)) %选择AIC值最小的模型
p_test = test(k,1);
q_test = test(k,2);
break;
end
end
%------1阶预测-----------------
TempData=[TempData;zeros(step,1)];
n=iddata(TempData); 
m = armax(u,[p_test q_test]);
                                 %m = armax(u(1:ls),[p_test q_test]);        %armax(p,q),[p_test q_test]对应AIC值最小，自动回归滑动平均模型
P1=predict(m,n,1);
PreR=P1.OutputData;
PreR=PreR';
%----------还原差分-----------------
if size(SaveDiffData,2)~=0
for index=size(SaveDiffData,2):-1:1
PreR=cumsum([SaveDiffData(index),PreR]);
end
end 
  %-------------------预测趋势并返回结果----------------
mp1=polyfit([1:size(TrendData',2)],TrendData',1);
xt=[];
for j=1:step
xt=[xt,size(TrendData',2)+j];
end
TrendResult=polyval(mp1,xt);
PreData=TrendResult+PreR(size(SourceData',2)+1:size(PreR,2));
tempx=[TrendData',TrendResult]+PreR;    % tempx为预测结果
plot(tempx(1901:2000),'r');
hold on
plot(Data(1901:2000),'b');